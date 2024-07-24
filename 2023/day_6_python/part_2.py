from typing import Final, Tuple, List
from math import sqrt, ceil

FILENAME: Final[str] = "input"


def read_input(filename: str) -> Tuple[int, int]:
    with open(filename, "r") as f:
        lines: List[str] = f.readlines()
        times: List[int] = int("".join(lines[0].split()[1:]))
        distances: List[int] = int("".join(lines[1].split()[1:]))
        return (times, distances)


def record_press_time(record: Tuple[int, int]) -> Tuple[float, float]:
    """Computes the press times required to go a certain distance in the given race time."""
    # distance = press_time * (race_time - press_time)
    race_time: int = record[0]
    distance: int = record[1]
    return (
        (race_time - sqrt(race_time**2 - 4 * distance)) / 2.0,
        (race_time + sqrt(race_time**2 - 4 * distance)) / 2.0,
    )

def num_wins(record: Tuple[int, int]) -> int:
    press_times: Tuple[float, float] = record_press_time(record)
    min_time: int = int(press_times[0]) + 1
    max_time: int = int(ceil(press_times[1])) - 1
    return max_time - min_time + 1

def main():
    record: Tuple[int, int] = read_input(FILENAME)
    ways: int = num_wins(record)
    print("Final output:", ways)

if __name__ == "__main__":
    main()