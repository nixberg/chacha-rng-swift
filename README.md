![Swift](https://github.com/nixberg/chacha-rng-swift/workflows/Swift/badge.svg?branch=master)

# ChaCha

[ChaCha](https://cr.yp.to/chacha/chacha-20080128.pdf)-based [`RandomNumberGenerator`](https://developer.apple.com/documentation/swift/randomnumbergenerator) for Swift. [Compatible](https://github.com/nixberg/chacha-rng-compability-rs) with Rust’s [rand_chacha](https://crates.io/crates/rand_chacha).

# Usage

```Swift
import ChaCha

var rng = ChaCha() // ChaCha8, random seed, stream: 0.

SIMD2.random(in: 0..<1234, using: &rng)
```

```Swift
var rng = ChaCha(seed: .zero) // Seeded ChaCha8, stream: 0.

Int.random(in: 0..<1234, using: &rng) // 1032
```

```Swift
var rng = ChaCha(rounds: .twenty, seed: .zero, stream: 0)

var array = [UInt8](repeating: 0, count: 4)
rng.fill(&array[...]) // [118, 184, 224, 173]
```
