#!/usr/bin/env bash

# SPDX-FileCopyrightText: None
# SPDX-License-Identifier: CC0-1.0

# update-erlang.sh
#
# Bump Erlang/OTP patch releases (OTP 26, 27, 28) in nerves_system_br and
# optionally open a GitHub PR.
#
# Usage:
#   ./update-erlang.sh [options]
#
# Options:
#   --repo DIR     Path to nerves_system_br checkout (default: current dir)
#   --pr           Push branch and open a PR via `gh`
#   --dry-run      Print what would change without modifying anything
#
# Requirements: bash 4+, git, curl, tar (GNU recommended), gh (for --pr)
#
# How it works
# ────────────
# nerves_system_br carries erlang version support as a patch to Buildroot:
#   patches/buildroot/0007-erlang-support-OTP-21-28.patch
#
# That patch file touches three things inside Buildroot's package/erlang/:
#   erlang.mk    - ifeq chain mapping BR2_PACKAGE_ERLANG_N → VERSION + ERTS_VSN
#   erlang.hash  - SHA256 for each otp_src_*.tar.gz
#   {version}/   - per-version patch dirs (disksup busybox fix, etc.)
#
# A patch-level bump for OTP N requires:
#   1. ERLANG_VERSION = OLD  →  ERLANG_VERSION = NEW      (in erlang.mk block)
#   2. ERLANG_ERTS_VSN = OLD →  ERLANG_ERTS_VSN = NEW     (ditto)
#   3. otp_src_OLD.tar.gz   →  otp_src_NEW.tar.gz         (hash comment + value)
#   4. package/erlang/OLD/  →  package/erlang/NEW/         (dir references)
#
# ERTS version comes from erts/vsn.mk inside the OTP source tarball.
# SHA256 is fetched from the upstream SHA256.txt release asset.
#
# Additionally updates two files that track the default OTP version (OTP 28):
#   .tool-versions                               - asdf erlang version
#   support/docker/nerves_system_br/Dockerfile   - FROM hexpm/erlang:{tag}
#
# The Dockerfile tag is looked up in:
#   https://fhunleth.github.io/latest_elixir/erlang-tags.txt
# If no matching tag is found for a given version (e.g. hexpm hasn't built it
# yet), the Dockerfile update is skipped with a note.

set -euo pipefail

# ── Defaults ──────────────────────────────────────────────────────────────────

REPO_DIR="."
CREATE_PR=false
DRY_RUN=false

# OTP major versions to manage (oldest to newest; newest = default in erlang.mk)
OTP_MAJORS=(26 27 28)

PATCH_RELATIVE="patches/buildroot/0007-erlang-support-OTP-21-28.patch"
TOOL_VERSIONS_RELATIVE=".tool-versions"
DOCKERFILE_RELATIVE="support/docker/nerves_system_br/Dockerfile"
ERLANG_TAGS_URL="https://fhunleth.github.io/latest_elixir/erlang-tags.txt"

# The last entry in OTP_MAJORS is the default version tracked by .tool-versions
# and the Dockerfile.
DEFAULT_MAJOR="${OTP_MAJORS[-1]}"

# ── Argument parsing ──────────────────────────────────────────────────────────

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)   REPO_DIR="$2"; shift 2 ;;
    --pr)     CREATE_PR=true; shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

REPO_DIR="$(cd "$REPO_DIR" && pwd)"
PATCH_FILE="${REPO_DIR}/${PATCH_RELATIVE}"
TOOL_VERSIONS_FILE="${REPO_DIR}/${TOOL_VERSIONS_RELATIVE}"
DOCKERFILE="${REPO_DIR}/${DOCKERFILE_RELATIVE}"

# ── Helpers ───────────────────────────────────────────────────────────────────

log()  { printf '[update-erlang] %s\n' "$*" >&2; }
die()  { printf '[update-erlang] ERROR: %s\n' "$*" >&2; exit 1; }
check_cmd() { command -v "$1" &>/dev/null || die "Required command not found: $1"; }

# ── Sanity checks ─────────────────────────────────────────────────────────────

check_cmd git
check_cmd curl
check_cmd tar
[[ "$CREATE_PR" == true ]] && check_cmd gh

[[ -f "$PATCH_FILE" ]]      || die "Patch file not found: ${PATCH_FILE}"
[[ -f "$TOOL_VERSIONS_FILE" ]] || die ".tool-versions not found: ${TOOL_VERSIONS_FILE}"
[[ -f "$DOCKERFILE" ]]      || die "Dockerfile not found: ${DOCKERFILE}"
[[ -d "${REPO_DIR}/.git" ]] || die "Not a git repo: ${REPO_DIR}"

# ── Version discovery ─────────────────────────────────────────────────────────

# Current version for a given OTP major, read from the patch file.
# Greps for the added (+) ERLANG_VERSION line whose value starts with {major}.
current_otp_version() {
  local major="$1"
  grep "^+ERLANG_VERSION = ${major}\." "$PATCH_FILE" \
    | head -1 \
    | awk '{print $3}'
}

# Current ERTS VSN for a given OTP version string, read from the patch file.
current_erts_vsn() {
  local otp_version="$1"
  # The ERTS line immediately follows the ERLANG_VERSION line in the ifeq block.
  grep -A1 "^+ERLANG_VERSION = ${otp_version}$" "$PATCH_FILE" \
    | grep "^+ERLANG_ERTS_VSN = " \
    | awk '{print $3}'
}

# Latest released tag for the given OTP major using git ls-remote.
# Handles both N.M.P and N.M.P.Q (patch-on-patch) versioning.
latest_otp_version() {
  local major="$1"
  # --sort=-v:refname sorts as version strings descending; first result is latest.
  # Filter out ^{} deref lines; take the bare tag name.
  git ls-remote --tags --sort=-v:refname \
    https://github.com/erlang/otp \
    "refs/tags/OTP-${major}.*" 2>/dev/null \
    | grep -v '\^{}' \
    | head -1 \
    | sed 's|.*refs/tags/OTP-||'
}

# ── Tarball introspection ─────────────────────────────────────────────────────

# Fetch the ERTS version from erts/vsn.mk inside the OTP source tarball.
# Streams the tarball and extracts only the one small file; no full download.
fetch_erts_vsn() {
  local version="$1"
  local url="https://github.com/erlang/otp/releases/download/OTP-${version}/otp_src_${version}.tar.gz"
  local tmpdir
  tmpdir="$(mktemp -d)"
  # shellcheck disable=SC2064
  trap "rm -rf '${tmpdir}'" RETURN

  log "  Streaming tarball to extract erts/vsn.mk ..."
  if ! curl -fsSL "$url" \
      | tar xz -C "$tmpdir" \
        --no-same-owner \
        "otp_src_${version}/erts/vsn.mk" 2>/dev/null; then
    die "Failed to extract erts/vsn.mk from ${url}"
  fi

  local vsn_file="${tmpdir}/otp_src_${version}/erts/vsn.mk"
  [[ -f "$vsn_file" ]] || die "erts/vsn.mk not found after extraction"

  grep '^VSN' "$vsn_file" | head -1 | awk '{print $3}'
}

# Fetch the SHA256 hash for otp_src_{version}.tar.gz from the upstream release.
fetch_sha256() {
  local version="$1"
  local tarball="otp_src_${version}.tar.gz"
  local url="https://github.com/erlang/otp/releases/download/OTP-${version}/SHA256.txt"

  local sha256
  sha256="$(curl -fsSL "$url" | awk -v t="$tarball" '$2 == t {print $1; exit}')"
  [[ -n "$sha256" ]] || die "Could not find SHA256 for ${tarball} in ${url}"
  echo "$sha256"
}

# ── Patch file editing ────────────────────────────────────────────────────────

# Update one OTP major's entries inside the patch file.
# All substitutions are version-string-unique, so plain sed -i is safe.
update_patch_for_major() {
  local major="$1"
  local old_ver="$2"
  local new_ver="$3"
  local old_erts="$4"
  local new_erts="$5"
  local old_sha256="$6"
  local new_sha256="$7"

  log "  Patching erlang.mk  : ERLANG_VERSION  ${old_ver} -> ${new_ver}"
  sed -i "s|^+ERLANG_VERSION = ${old_ver}$|+ERLANG_VERSION = ${new_ver}|" "$PATCH_FILE"

  log "  Patching erlang.mk  : ERLANG_ERTS_VSN ${old_erts} -> ${new_erts}"
  sed -i "s|^+ERLANG_ERTS_VSN = ${old_erts}$|+ERLANG_ERTS_VSN = ${new_erts}|" "$PATCH_FILE"

  log "  Patching erlang.hash: ${old_sha256:0:16}…  otp_src_${old_ver}"
  log "                     -> ${new_sha256:0:16}…  otp_src_${new_ver}"
  # Hash value line
  sed -i "s|^+sha256  ${old_sha256}  otp_src_${old_ver}.tar.gz$|+sha256  ${new_sha256}  otp_src_${new_ver}.tar.gz|" "$PATCH_FILE"
  # Comment line above it
  sed -i "s|^+# From .*/OTP-${old_ver}/SHA256.txt$|+# From https://github.com/erlang/otp/releases/download/OTP-${new_ver}/SHA256.txt|" "$PATCH_FILE"

  # Rename version-specific directory references in ALL buildroot patch files,
  # not just 0007. Any patch that adds a package/erlang/{version}/ directory
  # (e.g. 0015-erlang-use-available-memory-*.patch) needs the same treatment.
  local patches_dir="${REPO_DIR}/patches/buildroot"
  local affected
  affected="$(grep -rl "package/erlang/${old_ver}/" "$patches_dir" 2>/dev/null || true)"

  if [[ -n "$affected" ]]; then
    while IFS= read -r pfile; do
      log "  Patching dir refs in $(basename "$pfile"): ${old_ver}/ -> ${new_ver}/"
      sed -i "s|package/erlang/${old_ver}/|package/erlang/${new_ver}/|g" "$pfile"
      MODIFIED_PATCHES+=("$pfile")
    done <<< "$affected"
  fi
}

# ── .tool-versions and Dockerfile ────────────────────────────────────────────

# Update the asdf .tool-versions file with the new default OTP version.
update_tool_versions() {
  local old_ver="$1"
  local new_ver="$2"
  log ".tool-versions: erlang ${old_ver} -> ${new_ver}"
  sed -i "s|^erlang ${old_ver}$|erlang ${new_ver}|" "$TOOL_VERSIONS_FILE"
  grep -q "^erlang ${new_ver}$" "$TOOL_VERSIONS_FILE" \
    || die ".tool-versions update failed: expected 'erlang ${new_ver}'"
}

# Update the Dockerfile FROM line to the latest hexpm/erlang tag for new_ver.
# Fetches the erlang-tags.txt curated list and greps for a ubuntu-noble tag
# matching the exact OTP version.  Skips with a note if none is found -- this
# happens when hexpm hasn't built the image yet.
update_dockerfile() {
  local old_ver="$1"
  local new_ver="$2"

  log "Dockerfile: fetching ${ERLANG_TAGS_URL} ..."
  local tags_content
  if ! tags_content="$(curl -fsSL "$ERLANG_TAGS_URL" 2>/dev/null)"; then
    log "Dockerfile: WARNING: could not fetch ${ERLANG_TAGS_URL} -- skipping"
    return
  fi

  # Look for a tag of the form {new_ver}-ubuntu-noble-{date}
  local new_tag
  new_tag="$(printf '%s\n' "$tags_content" \
    | grep "^${new_ver}-ubuntu-noble-" \
    | head -1)"

  if [[ -z "$new_tag" ]]; then
    log "Dockerfile: NOTE: no hexpm/erlang tag found for ${new_ver} in erlang-tags.txt."
    log "           hexpm may not have built it yet. Dockerfile left unchanged."
    return
  fi

  # Extract the current full tag from the FROM line so we can report what changed.
  local old_tag
  old_tag="$(grep "^FROM hexpm/erlang:" "$DOCKERFILE" | head -1 | sed 's|FROM hexpm/erlang:||')"

  if [[ "$old_tag" == "$new_tag" ]]; then
    log "Dockerfile: already at hexpm/erlang:${new_tag}"
    return
  fi

  log "Dockerfile: FROM hexpm/erlang:${old_tag}"
  log "         -> FROM hexpm/erlang:${new_tag}"
  sed -i "s|^FROM hexpm/erlang:${old_tag}$|FROM hexpm/erlang:${new_tag}|" "$DOCKERFILE"
  grep -q "^FROM hexpm/erlang:${new_tag}$" "$DOCKERFILE" \
    || die "Dockerfile FROM update failed"
}

# ── Main loop ─────────────────────────────────────────────────────────────────

CHANGES=()
MODIFIED_PATCHES=()

log "Checking OTP majors: ${OTP_MAJORS[*]}"

declare -A CURRENT_VERS NEW_VERS

for MAJOR in "${OTP_MAJORS[@]}"; do
  CURRENT="$(current_otp_version "$MAJOR")"
  [[ -n "$CURRENT" ]] || die "Could not determine current OTP ${MAJOR} version from patch file"

  log "OTP ${MAJOR}: current = ${CURRENT}, querying latest..."
  LATEST="$(latest_otp_version "$MAJOR")"
  [[ -n "$LATEST" ]] || die "Could not determine latest OTP ${MAJOR} release from git ls-remote"

  CURRENT_VERS[$MAJOR]="$CURRENT"
  NEW_VERS[$MAJOR]="$LATEST"

  if [[ "$CURRENT" == "$LATEST" ]]; then
    log "OTP ${MAJOR}: already at ${CURRENT}, nothing to do"
    continue
  fi

  log "OTP ${MAJOR}: ${CURRENT} -> ${LATEST}"

  OLD_ERTS="$(current_erts_vsn "$CURRENT")"
  [[ -n "$OLD_ERTS" ]] || die "Could not determine current ERTS VSN for OTP ${CURRENT}"
  OLD_SHA="$(grep "^+sha256  .*  otp_src_${CURRENT}.tar.gz$" "$PATCH_FILE" | awk '{print $2}')"
  [[ -n "$OLD_SHA" ]] || die "Could not find current SHA256 for otp_src_${CURRENT}.tar.gz in patch"

  if [[ "$DRY_RUN" == true ]]; then
    log "OTP ${MAJOR}: [dry-run] would update ${CURRENT} -> ${LATEST}"
    CHANGES+=("OTP-${MAJOR}: ${CURRENT} -> ${LATEST}")
    continue
  fi

  log "OTP ${MAJOR}: fetching ERTS version for ${LATEST}..."
  NEW_ERTS="$(fetch_erts_vsn "$LATEST")"
  log "OTP ${MAJOR}: ERTS ${OLD_ERTS} -> ${NEW_ERTS}"

  log "OTP ${MAJOR}: fetching SHA256 for ${LATEST}..."
  NEW_SHA="$(fetch_sha256 "$LATEST")"

  log "OTP ${MAJOR}: applying changes to patch file..."
  update_patch_for_major \
    "$MAJOR" \
    "$CURRENT" "$LATEST" \
    "$OLD_ERTS" "$NEW_ERTS" \
    "$OLD_SHA" "$NEW_SHA"

  CHANGES+=("OTP-${MAJOR}: ${CURRENT} -> ${LATEST}")
done

# ── Summary ───────────────────────────────────────────────────────────────────

if [[ "${#CHANGES[@]}" -eq 0 ]]; then
  log "All managed OTP versions are already up to date."
  exit 0
fi

if [[ "$DRY_RUN" == true ]]; then
  log "Dry run complete. Would update:"
  for c in "${CHANGES[@]}"; do log "  $c"; done
  # Preview .tool-versions / Dockerfile for the default major
  local_default_old="${CURRENT_VERS[$DEFAULT_MAJOR]:-}"
  local_default_new="${NEW_VERS[$DEFAULT_MAJOR]:-}"
  if [[ -n "$local_default_old" && "$local_default_old" != "$local_default_new" ]]; then
    log "  .tool-versions: erlang ${local_default_old} -> ${local_default_new}"
    log "  Dockerfile: FROM tag lookup deferred to non-dry-run (fetches ${ERLANG_TAGS_URL})"
  fi
  exit 0
fi

log "Changes applied:"
for c in "${CHANGES[@]}"; do log "  $c"; done

# Verify the patch file still parses sensibly (basic sanity)
if ! grep -q "^+ERLANG_VERSION = " "$PATCH_FILE"; then
  die "Sanity check failed: no +ERLANG_VERSION lines found after editing"
fi

# ── Update .tool-versions and Dockerfile for the default OTP major ────────────

DEFAULT_OLD="${CURRENT_VERS[$DEFAULT_MAJOR]:-}"
DEFAULT_NEW="${NEW_VERS[$DEFAULT_MAJOR]:-}"

if [[ -n "$DEFAULT_OLD" && -n "$DEFAULT_NEW" && "$DEFAULT_OLD" != "$DEFAULT_NEW" ]]; then
  update_tool_versions "$DEFAULT_OLD" "$DEFAULT_NEW"
  update_dockerfile    "$DEFAULT_OLD" "$DEFAULT_NEW"
else
  log ".tool-versions / Dockerfile: OTP ${DEFAULT_MAJOR} unchanged, skipping"
fi

# ── Commit and PR ─────────────────────────────────────────────────────────────

BRANCH="update-erlang-$(date +%Y%m%d-%H%M%S)"

COMMIT_TITLE="erlang: bump OTP patch releases"
COMMIT_BODY="$(printf '%s\n' "${CHANGES[@]}")"
COMMIT_MSG="${COMMIT_TITLE}

${COMMIT_BODY}"

PR_BODY="Automated OTP patch release bumps.

$(printf -- '- %s\n' "${CHANGES[@]}")

Generated by \`update-erlang.sh\`."

# Collect all files to stage: the main patch, tool-versions, Dockerfile, plus
# any additional patches that had directory references updated.
FILES_TO_ADD=(
  "$PATCH_RELATIVE"
  "$TOOL_VERSIONS_RELATIVE"
  "$DOCKERFILE_RELATIVE"
)
for pfile in "${MODIFIED_PATCHES[@]}"; do
  local_rel="${pfile#"${REPO_DIR}/"}"
  [[ "$local_rel" != "$PATCH_RELATIVE" ]] && FILES_TO_ADD+=("$local_rel")
done

if [[ "$CREATE_PR" == true ]]; then
  # Check for an existing open PR from a previous run of this script.
  EXISTING_PR="$(gh pr list \
    --repo nerves-project/nerves_system_br \
    --state open \
    --search "in:title ${COMMIT_TITLE}" \
    --json number,headRefName,body \
    --jq ".[] | select(.body | startswith(\"Automated OTP patch release bumps.\")) | [.number, .headRefName, (.body | @base64)] | @tsv" \
    | head -1)"

  if [[ -n "$EXISTING_PR" ]]; then
    EXISTING_NUM="$(echo "$EXISTING_PR" | cut -f1)"
    EXISTING_BRANCH="$(echo "$EXISTING_PR" | cut -f2)"
    EXISTING_BODY="$(echo "$EXISTING_PR" | cut -f3 | base64 -d | tr -d '\r')"

    # Compare just the version-bump lines — ignore template/checklist differences.
    EXISTING_CHANGES="$(echo "$EXISTING_BODY" | grep '^- OTP-' | sort)"
    EXPECTED_CHANGES="$(printf -- '- %s\n' "${CHANGES[@]}" | sort)"

    if [[ "$EXISTING_CHANGES" == "$EXPECTED_CHANGES" ]]; then
      log "Open PR #${EXISTING_NUM} (branch ${EXISTING_BRANCH}) already has the same changes. Nothing to do."
      git -C "$REPO_DIR" checkout -- "${FILES_TO_ADD[@]}"
      exit 0
    fi

    log "Open PR #${EXISTING_NUM} is outdated — closing it."
    gh pr close "$EXISTING_NUM" \
      --repo nerves-project/nerves_system_br \
      --delete-branch \
      --comment "Superseded by a newer run of \`update-erlang.sh\`."
  fi

  log "Creating branch ${BRANCH}..."
  git -C "$REPO_DIR" checkout -b "$BRANCH"
  git -C "$REPO_DIR" add "${FILES_TO_ADD[@]}"
  git -C "$REPO_DIR" commit -m "$COMMIT_MSG"
  git -C "$REPO_DIR" push origin "$BRANCH"

  log "Opening PR..."
  gh pr create \
    --repo nerves-project/nerves_system_br \
    --base main \
    --head "$BRANCH" \
    --title "$COMMIT_TITLE" \
    --body "$PR_BODY"

  log "Done. PR opened from branch ${BRANCH}."
else
  log "Changes written. Commit and PR creation skipped (pass --pr to enable)."
  log ""
  log "To commit manually:"
  log "  git -C '${REPO_DIR}' add ${FILES_TO_ADD[*]}"
  log "  git -C '${REPO_DIR}' commit -m '${COMMIT_TITLE}'"
fi

