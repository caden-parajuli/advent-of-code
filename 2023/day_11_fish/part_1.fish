set FILENAME input
set lines (cat $FILENAME | string split \n)
set LEN (count $lines)
set EMPTY (string repeat -n $LEN ".")

# Pre-fill empty columns
for x in (seq $LEN)
    set -a tempEmptyCols 1
end

echo "Read $LEN lines"
echo "Finding galaxies..."

for y in (seq $LEN)
    set line (string split '' $lines[$y])

    # Empty lines
    if [ $lines[$y] = $EMPTY ]
        set -a emptyRows $y
    end

    for x in (seq $LEN)
        if test $line[$x] = "#"
            set -a galaxies "$x;$y"
            set tempEmptyCols[$x] 0
        end
    end
end

echo "$(count $galaxies) galaxies found."
echo "Processing emptiness..."

for col in (seq (count $tempEmptyCols))
    if test $tempEmptyCols[$col] -eq 1
        set -a emptyCols $col
    end
end

echo "Emptiness processed."
echo "Expanding universe..."

for i in (seq (count $galaxies))
    set galaxy (string split ';' $galaxies[$i])
    set newX $galaxy[1]
    set newY $galaxy[2]

    for col in $emptyCols
        if test $col -lt $galaxy[1]
            set newX (math $newX + 1)
        end
    end

    for row in $emptyRows
        if test $row -lt $galaxy[2]
            # echo "Expanded row"
            set newY (math $newY + 1)
        end
    end

    set galaxies[$i] "$newX;$newY"
end

echo "Universe expanded."
echo "Measuring distances (takes a while)..."

set total 0
for i in (seq (count $galaxies))
    # echo "Computing Galaxy $i distances"
    set galaxy1 (string split ';' $galaxies[$i])
    for j in (seq (math $i + 1) (count $galaxies))
        set galaxy2 (string split ';' $galaxies[$j])
        # Add the regular distance
        set total (math "$total + abs ( $galaxy2[1] - $galaxy1[1] ) + abs ( $galaxy2[2] - $galaxy1[2] )")
    end
end

echo "Final total: $total"
