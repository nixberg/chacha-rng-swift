public struct ChaCha20RNG: RandomNumberGenerator {
    private var rng: ChaChaRNG
    
    public init() {
        rng = ChaChaRNG(rounds: 20)
    }
    
    public init(seed: SIMD8<UInt32>, stream: UInt64 = 0) {
        rng = ChaChaRNG(seed: seed, stream: stream, rounds: 20)
    }
    
    public mutating func next() -> UInt8 {
        rng.next()
    }
    
    public mutating func next() -> UInt16 {
        rng.next()
    }
    
    public mutating func next() -> UInt32 {
        rng.next()
    }
    
    public mutating func next() -> UInt64 {
        rng.next()
    }
    
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    public mutating func next() -> Float16 {
        rng.next()
    }
#endif
    
    public mutating func next() -> Float32 {
        rng.next()
    }
    
    public mutating func next() -> Float64 {
        rng.next()
    }
    
    public mutating func fill(_ buffer: UnsafeMutableRawBufferPointer) {
        rng.fill(buffer)
    }
}
