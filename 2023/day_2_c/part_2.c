#include <stdio.h>
#include <stdlib.h>

#include "common.h"

#define MAX_LINE_LEN 256

int game(char * line);

int main(int argc, char * argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Please specify an input filename\n");
        return EXIT_FAILURE;
    }

    char * filename = argv[1];
    FILE * input_file = fopen(filename, "r");
    char line[MAX_LINE_LEN];
    int total = 0;

    while (fgets(line, MAX_LINE_LEN, input_file)) {
        total += game(line);
    }

    printf("Total: %d\n", total);
}

/**
 * Returns 0 if game is impossible, otherwise returns the power of the minimum set.
 */
int game(char * line) {
    int i = 5;
    int game_id = read_num(line, &i);
    i += 2;

    int max_red = 0;
    int max_green = 0;
    int max_blue = 0;

    while (1) {
        int num_cubes = read_num(line, &i);
        ++i;

        switch (line[i]) {
            case 'r':
                if (num_cubes > max_red) {
                    max_red = num_cubes;
                }
                break;
            case 'g':
                if (num_cubes > max_green) {
                    max_green = num_cubes;
                }
                break;
            case 'b':
                if (num_cubes > max_blue) {
                    max_blue = num_cubes;
                }
                break;
        }

        while (line[i] != ',' && line[i] != ';' && line[i] != '\n' && line[i] != '\0') {
            ++i;
        }
        switch (line[i]) {
            case ',':
            case ';':
                i += 2;
                break;
            case '\n':
            case '\0':
                return max_red * max_green * max_blue;
            default:
                exit(EXIT_FAILURE);
        }
    }
}
