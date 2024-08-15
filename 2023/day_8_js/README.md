# Day 8: JavaScript

## Running

You'll need to spin up a webserver to run this, since it loads data from a file which can't be done outside a webserver for security reasons.

## Comments

This solution technically cannot solve the general case that the problem appears to present, although solving the general case would not be terribly difficult; one would just have to take note of the periods of the cycles and the location of the Z values separately, resulting in the Diophantine system,

```
x = z_1 mod n_1
x = z_2 mod n_2
...
x = z_k mod n_k
```

Which can be solved using the Chinese Remainder Theorem. Technically it is possible that loops contain multiple Z values, but this merely creates at most a few more such systems, each of which can be solved quickly. In practice, the AoC inputs appear to always be sufficiently nice that none of these techniques are necessary.
