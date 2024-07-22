import std/[intsets, strutils]

const filename = "input"

func score_line(line: string): int =
    var
        winning_set = initIntSet()
    let 
        cards = line.split(':')[1].split('|')
        winning = cards[0]
        own = cards[1]
    result = 0

    for win in winning.splitWhitespace():
        winning_set.incl(parseInt(win))

    for card in own.splitWhitespace():
        if parseInt(card) in winning_set:
            if result == 0:
                result = 1
            else:
                result *= 2


proc main() =
    var total = 0
    for line in lines filename:
        total += score_line(line)

    echo "Final total: " & $total

main()
