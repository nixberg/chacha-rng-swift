import Algorithms
import ChaCha

struct ChaChaRNG: RandomNumberGenerator {
    private var state: State
    private var workingState: WorkingState
    private var position: Int
    
    private let rounds: Int
    
    init(rounds: Int) {
        self.init(seed: .random(), stream: 0, rounds: rounds)
    }
    
    init(seed: SIMD8<UInt32>, stream: UInt64 = 0, rounds: Int) {
        state = State(key: seed, nonce: stream)
        
        workingState = state.permuted(rounds: rounds)
        state.incrementCounter()
        position = 0
        
        self.rounds = rounds
    }
    
    mutating func next() -> UInt8 {
        UInt8(truncatingIfNeeded: self.next() as UInt32)
    }

    mutating func next() -> UInt16 {
        UInt16(truncatingIfNeeded: self.next() as UInt32)
    }
    
    mutating func next() -> UInt32 {
        assert((0...16).contains(position))
        
        if position == 16 {
            workingState = state.permuted(rounds: rounds)
            state.incrementCounter()
            position = 0
        }
        
        defer { position &+= 1 }
        return workingState.withUnsafeBytes {
            $0.withMemoryRebound(to: UInt32.self) {
                $0[position]
            }
        }
    }
    
    mutating func next() -> UInt64 {
        UInt64(self.next() as UInt32) | UInt64(self.next() as UInt32) << 32
    }
    
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    mutating func next() -> Float16 {
        Float16(self.next() as UInt16 >> 05) * 0x1p-11
    }
#endif
    
    mutating func next() -> Float32 {
        Float32(self.next() as UInt32 >> 08) * 0x1p-24
    }
    
    mutating func next() -> Float64 {
        Float64(self.next() as UInt64 >> 11) * 0x1p-53
    }
    
    mutating func fill(_ buffer: UnsafeMutableRawBufferPointer) {
        for bufferIndices in buffer.indices.chunks(ofCount: 4) {
            withUnsafeBytes(of: self.next() as UInt32) {
                for (bufferIndex, index) in zip(bufferIndices, $0.indices) {
                    buffer[bufferIndex] = $0[index]
                }
            }
        }
    }
}

extension SIMD8<UInt32> {
    fileprivate static func random() -> Self {
        var rng = SystemRandomNumberGenerator()
        var result = Self()
        for index in result.indices {
            result[index] = rng.next()
        }
        return result
    }
}
