# Release checklist

  1. Update `CHANGELOG.md` with a bulletpoint list of new features and bug fixes
  2. Update the version numbers in `VERSION`
  3. Double check `mix.exs` to make sure that all files are listed in `files`.
  3. Commit changes
  3. Tag
  4. Push last commit(s) *and* tags to GitHub
  6. Copy the latest CHANGELOG.md entry to the GitHub releases description
  7. Run `mix hex.publish package`
  8. Update version numbers in `CHANGELOG.md` and `VERSION` for upcoming `-dev` work
