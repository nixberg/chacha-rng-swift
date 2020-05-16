# ChaCha

[ChaCha](https://cr.yp.to/chacha/chacha-20080128.pdf)-based [`RandomNumberGenerator`](https://developer.apple.com/documentation/swift/randomnumbergenerator) for Swift. [Compatible](https://github.com/nixberg/chacha-rng-compability-rs) with Rust’s [rand_chacha](https://crates.io/crates/rand_chacha).

# Usage

```Swift
import ChaCha

var rng = ChaCha(seed: .zero)
print(Int.random(in: 0..<1234, using: &rng)) // 1032

rng = ChaCha() // Using a random seed.
print(SIMD2.random(in: 0..<1234, using: &rng))

rng = ChaCha(rounds: .twenty, seed: .zero, streamID: 0)
var array = [UInt8](repeating: 0, count: 4)
rng.fill(&array[...])
print(array) // [118, 184, 224, 173]
```
