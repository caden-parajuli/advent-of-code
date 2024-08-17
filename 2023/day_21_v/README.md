# Day 21: V

## Language

Although V was fairly easy to pick up, it left me feeling unfulfilled. It wasn't very fun to write (some of the pains of C with none of the benefits), and I can't think of any scenario where it could be used in which C, Rust, Nim, or Zig wouldn't be a much better fit, except possibly when development requires ZERO dependencies other than a C compiler. However, I also can't think of a reason that would ever be necessary, unless I was compiling on my own half-baked OS.

The most infuriating part of V was that panics didn't print full stack traces. I'm aware I could have used a debugger, but for a language that already has panic functionality I expect the panics to be at least somewhat useful.

## Problem

The first part was quite straightforward. I decided to use Dijkstra's algorithm simply because it's been a while since I had to use it. For part 2, I used a quadratic interpolation approach based on the special structure of the input. I didn't think to try this until after many attempts to calculate the total directly based on the shape of the covered area directly, which had too many special cases to be reliable without testing data. All-in-all part 2 wasn't very hard, but required a good dealof thought.

## Running

Install V **version 0.4.4** (the version is important) and run `v run .` in today's root directory (this one).
