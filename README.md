![Swift](https://github.com/nixberg/chacha-rng-swift/workflows/Swift/badge.svg)

# ChaCha

[ChaCha](https://cr.yp.to/chacha/chacha-20080128.pdf)-based [`RandomNumberGenerator`](https://developer.apple.com/documentation/swift/randomnumbergenerator) for Swift. [Compatible](https://github.com/nixberg/chacha-rng-compability-rs) with Rust’s [rand_chacha](https://crates.io/crates/rand_chacha).

# Usage

### CSRNG

You should almost certainly use `SystemRandomNumberGenerator` instead.

```Swift
import ChaCha

var rng = ChaCha() // ChaCha8, random seed, stream: 0.

SIMD2.random(in: 0..<1234, using: &rng)
```

### CSPRNG

```Swift
var rng = ChaCha(seed: .zero) // Seeded ChaCha8, stream: 0.

Int.random(in: 0..<1234, using: &rng) // 1032
```

### Fill `ArraySlice`

```Swift
var rng = ChaCha(rounds: .twenty, seed: .zero, stream: 0)

var array = [UInt8](repeating: 0, count: 4)
rng.fill(&array[...]) // [118, 184, 224, 173]
```

### Generate `Array`

```Swift
var rng = ChaCha(rounds: .twenty, seed: .zero, stream: 0)

let array: [UInt8] = rng.generateArray(count: 4) // [118, 184, 224, 173]
```

### Append to `RangeReplaceableCollection`

```Swift
var rng = ChaCha(rounds: .twenty, seed: .zero, stream: 0)

var array: [UInt8] = [0]
rng.append(to: &array, count: 4) // [0, 118, 184, 224, 173]
```
