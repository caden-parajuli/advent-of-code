# Day 17: Julia

## Rules

I have made an exception for the general "no libraries" rule, simply because (much like LaTeX) I have gotten the impression that Julia is not meant to be used without its ecosystem. And what an ecosystem it is! I didn't expect to have such easy access to an implementation of A*.

## Language

Overall, I think I like Julia. It often feels like a slightly more verbose Python with a greater math focus (which I love). Unfortunately, I tend to care about performance too much to see any personal use for it beyond quick scripting or to check some math (which is nevertheless a good use case). The only footgun I've encountered so far is the 1-based indexing. Lua has a pass for being 1-based since its "arrays" are really hashmaps, but Julia has no such pass. I understand they're trying to cater to the mathematical/research community, but in my mathematical studies 0-based indexing has been quite common. I guess the precedent set by Mathematica et al. is too strong too break.
