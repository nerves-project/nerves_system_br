#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Line to match for the serial number.
static const char to_match[] = "Serial\t\t: ";

int main(int argc, char *argv[])
{
    const char *serial = "0000000000000000"; // Serial number to print on error
    FILE *fp = fopen("/proc/cpuinfo", "r");
    char line[256];
    if (fp) {
        while (fgets(line, sizeof(line), fp)) {
            if (memcmp(line, to_match, sizeof(to_match) - 1) == 0) {
                serial = line + sizeof(to_match) - 1;

                // Trim off the '\n' at the end
                line[strlen(line) - 1] = '\0';
                break;
            }
        }
        fclose(fp);
    }

    // The user may specify how many digits to print
    int offset = 0;
    if (argc > 1) {
        int digits = strtol(argv[1], 0, 0);
        int max_offset = strlen(serial);
        offset = max_offset - digits;
        if (offset < 0)
            offset = 0;
        else if (offset > max_offset)
            offset = max_offset;
    }
    printf("%s", serial + offset);
    exit(EXIT_SUCCESS);
}
