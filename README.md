[![Swift](https://github.com/nixberg/chacha-rng-swift/actions/workflows/swift.yaml/badge.svg)](
https://github.com/nixberg/chacha-rng-swift/actions/workflows/swift.yaml)

# chacha-rng-swift

[ChaCha](https://cr.yp.to/chacha.html)-based [`RandomNumberGenerator`](
https://developer.apple.com/documentation/swift/randomnumbergenerator). 
[Compatible](https://github.com/nixberg/chacha-rng-compability-rs) with Rust’s [rand_chacha](
https://crates.io/crates/rand_chacha).

# Usage

### CSRNG

You should almost certainly use `SystemRandomNumberGenerator` instead.

```swift
import ChaChaRNG

var rng = ChaCha8RNG() // Seeded via SystemRandomNumberGenerator, stream: 0.

SIMD2.random(in: 0..<1234, using: &rng)
```

### CSPRNG

```swift
var rng = ChaCha8RNG(seed: .zero) // All-zero seed, stream: 0.

Int.random(in: 0..<1234, using: &rng) // 1032
```

### Individual unsigned integers

```swift
var rng = ChaCha20RNG(seed: .zero)

rng.next() as UInt8  // 118
rng.next() as UInt16 // 61856
rng.next() as UInt32 // 3848953152
rng.next() as UInt64 // 13265865887270667859
```

Equivalent Rust:

```rust
let mut rng = ChaChaRng::from_seed([0u8; 32]);

println!("{}", rng.gen::<u8>());  // 118
println!("{}", rng.gen::<u16>()); // 61856
println!("{}", rng.gen::<u32>()); // 3848953152
println!("{}", rng.gen::<u64>()); // 13265865887270667859
```

### Individual floating-point numbers

```swift
var rng = ChaCha20RNG(seed: .zero)

rng.next() as Float16 // Only supported on some hardware.
rng.next() as Float32 // 0.56344515
rng.next() as Float64 // 0.15914191768880792
```

Equivalent Rust:

```rust
let mut rng = ChaChaRng::from_seed([0u8; 32]);

println!("{}", rng.gen::<f32>()); // 0.6792102
println!("{}", rng.gen::<f32>()); // 0.56344515
println!("{}", rng.gen::<f64>()); // 0.15914191768880792
```

### Fill buffers:

```swift
var rng = ChaCha20RNG(seed: .zero)
        
var array = [UInt8](repeating: 0, count: 5)
array.withUnsafeMutableBytes {
    rng.fill($0)
}
array // [118, 184, 224, 173, 160]
```

Equivalent Rust:

```rust
let mut rng = ChaChaRng::from_seed([0u8; 32]);

let mut array = [0u8; 5];
rng.fill(&mut a[..]);
println!("{:?}", array); // [118, 184, 224, 173, 160]
```
