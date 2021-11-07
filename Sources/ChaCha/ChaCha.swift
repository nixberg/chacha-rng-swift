public enum Rounds: Int {
    case eight  =  8
    case twelve = 12
    case twenty = 20
}

public struct ChaCha: RandomNumberGenerator {
    public let rounds: Rounds
    
    private var state: State
    private var workingState: State = .init()
    private var wordIndex = 16
    
    public init(rounds: Rounds = .eight) {
        self.rounds = rounds
        state = State(.random(), 0)
    }
    
    public init(rounds: Rounds = .eight, seed: SIMD8<UInt32>, stream: UInt64 = 0) {
        self.rounds = rounds
        state = State(seed, stream)
    }
    
    public mutating func next() -> UInt8 {
        UInt8(truncatingIfNeeded: self.next() as UInt32)
    }
    
    public mutating func next() -> UInt16 {
        UInt16(truncatingIfNeeded: self.next() as UInt32)
    }
    
    public mutating func next() -> UInt32 {
        assert((0...16).contains(wordIndex))
        
        if wordIndex == 16 {
            workingState = state
            
            for _ in stride(from: 0, to: rounds.rawValue, by: 2) {
                workingState.doubleRound()
            }
            
            workingState &+= state
            
            state.incrementCounter()
            wordIndex = 0
        }
        
        defer { wordIndex &+= 1 }
        return workingState[wordIndex] // TODO: .littleEndian?
    }
    
    public mutating func next() -> UInt64 {
        let lo: UInt32 = self.next()
        let hi: UInt32 = self.next()
        return (UInt64(hi) << 32) | UInt64(lo)
    }
    
    #if swift(>=5.4) && !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
    public mutating func next() -> Float16 {
        Float16(self.next() as UInt16 >> 5) * 0x1p-11
    }
    #endif
    
    public mutating func next() -> Float32 {
        Float32(self.next() as UInt32 >> 8) * 0x1p-24
    }
    
    public mutating func next() -> Float64 {
        Float64(self.next() as UInt64 >> 11) * 0x1p-53
    }
}

fileprivate struct State {
    var a: SIMD4<UInt32>
    var b: SIMD4<UInt32>
    var c: SIMD4<UInt32>
    var d: SIMD4<UInt32>
    
    init() {
        a = .zero
        b = .zero
        c = .zero
        d = .zero
    }
    
    init(_ seed: SIMD8<UInt32>, _ stream: UInt64) {
        a = SIMD4(0x61707865, 0x3320646e, 0x79622d32, 0x6b206574)
        b = seed.lowHalf
        c = seed.highHalf
        let lo = UInt32(truncatingIfNeeded: stream)
        let hi = UInt32(truncatingIfNeeded: stream >> 32)
        d = SIMD4(0, 0, lo, hi)
    }
    
    @inline(__always)
    mutating func incrementCounter() {
        d.x &+= 1
        if d.x == 0 {
            d.y &+= 1
            assert(d.y != 0)
        }
    }
    
    @inline(__always)
    mutating func doubleRound() {
        self.round()
        self.diagonalize()
        self.round()
        self.undiagonalize()
    }
    
    @inline(__always)
    private mutating func round() {
        a &+= b
        d ^= a
        d.rotate(left: 16)
        
        c &+= d
        b ^= c
        b.rotate(left: 12)
        
        a &+= b
        d ^= a
        d.rotate(left: 8)
        
        c &+= d
        b ^= c
        b.rotate(left: 7)
    }
    
    @inline(__always)
    private mutating func diagonalize() {
        b = b[SIMD4(1, 2, 3, 0)]
        c = c[SIMD4(2, 3, 0, 1)]
        d = d[SIMD4(3, 0, 1, 2)]
    }
    
    @inline(__always)
    private mutating func undiagonalize() {
        b = b[SIMD4(3, 0, 1, 2)]
        c = c[SIMD4(2, 3, 0, 1)]
        d = d[SIMD4(1, 2, 3, 0)]
    }
    
    @inline(__always)
    static func &+= (lhs: inout Self, rhs: Self) {
        lhs.a &+= rhs.a
        lhs.b &+= rhs.b
        lhs.c &+= rhs.c
        lhs.d &+= rhs.d
    }
    
    @inline(__always)
    subscript(index: Int) -> UInt32 {
        assert((0..<16).contains(index))
        return withUnsafePointer(to: self) {
            $0.withMemoryRebound(to: UInt32.self, capacity: 16) {
                $0[index]
            }
        }
    }
}

fileprivate extension SIMD8 where Scalar == UInt32 {
    static func random() -> Self {
        var rng = SystemRandomNumberGenerator()
        var result = Self()
        for i in result.indices {
            result[i] = rng.next()
        }
        return result
    }
}

fileprivate extension SIMD4 where Scalar == UInt32 {
    @inline(__always)
    mutating func rotate(left count: Self.Scalar) {
        let countComplement = Self.Scalar(Self.Scalar.bitWidth) - count
        self = (self &<< count) | (self &>> (countComplement))
    }
}
