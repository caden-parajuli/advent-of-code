#include <stdio.h>
#include <stdlib.h>

#include "common.h"

#define MAX_LINE_LEN 256

#define MAX_RED 12
#define MAX_GREEN 13
#define MAX_BLUE 14

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
 * Returns the maximum number of cubes for the color
 * whose first character is the given char
 */
int max_num(char color) {
    switch (color) {
        case 'r': 
            return MAX_RED;
        case 'g': 
            return MAX_GREEN;
        case 'b': 
            return MAX_BLUE;
        default:
            return 0;
    }
}

/**
 * Returns 0 if game is impossible, otherwise returns the Game ID.
 */
int game(char * line) {
    int i = 5;
    int game_id = read_num(line, &i);
    i += 2;

    while (1) {
        int num_cubes = read_num(line, &i);

        ++i;
        if (num_cubes > max_num(line[i])) {
            return 0;
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
                return game_id;
            default:
                exit(EXIT_FAILURE);
        }
    }
}
