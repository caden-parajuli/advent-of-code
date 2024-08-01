# Day 12: Dart

## Problem

For the first part, I simply used a brute force. I did have an inkling that part 2 would probably do something like on Day 11 by expanding the input to render brute-force too slow, and I was right. My solution for part 2 uses dynamic programming. The solution is fairly simple, but all the different cases are annoying to keep track of. It took me a little while to come up with the proper function to apply dynamic programming, since due to my approach in part 1 I kept thinking of mutated strings as the input, rather than position and group/space data. Once I made that switch, it was very straightforward.

## Language

Although Dart sometimes feels a little verbose for what it is, it is surprisingly intuitive, and has a Goldilocks-sized standard library. I could easily get used to using it for tasks like this. Then only thing that bothers me at times is the inability to use any kind of references or pointers, although I realize this is very much not its intended design; I'm just too used to systems programming.
