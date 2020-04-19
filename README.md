# ChaChaRNG

[ChaCha](https://cr.yp.to/chacha/chacha-20080128.pdf)-based `RandomNumberGenerator` for Swift.

# Usage

```Swift
import ChaChaRNG

var rng = ChaChaRNG(seed: .zero)
print(Int.random(in: 0..<1234, using: &rng)) // 1032

rng = ChaChaRNG() // Using a random seed.
print(SIMD2.random(in: 0..<1234, using: &rng))
```
