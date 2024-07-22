import std/[intsets, strutils, sequtils]

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
            result += 1

# Scores a sequence of cards, returning the resulting sequence of copies,
# and the total number of copies produced
func score_cards(lines: seq[string], cards: seq[int]) : seq[int] =
    var
        copies = newSeq[int]()
    for card in cards:
        let score = score_line(lines[card])
        copies.add(toSeq((card + 1)..(card + score)))
    return copies

# Iteratively socres all cards and the copies they recursively produce
proc score_all(lines: seq[string]) : int =
    var
        cards = toSeq(0 ..< lines.len)
    result = lines.len
    while cards.len != 0:
        echo "Current cards: " & $cards.len
        cards = score_cards(lines, cards)
        result += cards.len


proc main() =
    let input = toSeq(lines filename)
    let total = score_all(input)

    echo "Final total: " & $total

main()
