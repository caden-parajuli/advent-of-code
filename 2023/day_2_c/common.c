/**
 * Reads a number from the line buffer starting at position pos.
 * Updates pos to point to character after number.
 */
int read_num(const char * const line, int * const pos) {
    int total = 0;
    while ('0' <= line[*pos] && line[*pos] <= '9') {
        total *= 10;
        total += line[*pos] - '0';
        *pos += 1;
    }

    return total;
}
