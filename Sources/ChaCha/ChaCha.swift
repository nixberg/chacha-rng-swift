public enum Rounds: Int {
    case eight = 8
    case twelve = 12
    case twenty = 20
}

public struct ChaCha: RandomNumberGenerator {
    public let rounds: Rounds
    
    private var state: State
    private var workingState = State()
    private var index = 0
    
    public init() {
        rounds = .eight
        state = State(.random(in: 0...UInt32.max), 0)
    }
    
    public init(rounds: Rounds) {
        self.rounds = rounds
        state = State(.random(in: 0...UInt32.max), 0)
    }
    
    public init(rounds: Rounds = .eight, seed: SIMD8<UInt32>, streamID: UInt64 = 0) {
        self.rounds = rounds
        state = State(seed, streamID)
    }
    
    public mutating func next() -> UInt32 {
        if index.isMultiple(of: 16) {
            self.block()
        }
        
        defer {
            index += 1
        }
        
        return withUnsafePointer(to: workingState) {
            $0.withMemoryRebound(to: UInt32.self, capacity: 16) {
                UInt32(littleEndian: $0[index % 16])
            }
        }
    }
    
    public mutating func next() -> UInt64 {
        let low = UInt64(truncatingIfNeeded: self.next() as UInt32)
        let high = UInt64(truncatingIfNeeded: self.next() as UInt32)
        return (high &<< 32) | low
    }
    
    private mutating func block() {
        workingState = state
        
        for _ in stride(from: 0, to: rounds.rawValue, by: 2) {
            workingState.doubleRound()
        }
        
        workingState &+= state
        
        state.incrementCounter()
    }
}

fileprivate struct State {
    private var a: SIMD4<UInt32>
    private var b: SIMD4<UInt32>
    private var c: SIMD4<UInt32>
    private var d: SIMD4<UInt32>
    
    init() {
        a = .zero
        b = .zero
        c = .zero
        d = .zero
    }
    
    init(_ seed: SIMD8<UInt32>, _ streamID: UInt64) {
        a = SIMD4(0x61707865, 0x3320646e, 0x79622d32, 0x6b206574)
        b = seed.lowHalf
        c = seed.highHalf
        d = SIMD4(
            0,
            0,
            UInt32(truncatingIfNeeded: streamID),
            UInt32(truncatingIfNeeded: streamID &>> 32)
        )
        
        a = a.littleEndian
        b = b.littleEndian
        c = c.littleEndian
        d = d.littleEndian
    }
    
    @inline(__always)
    mutating func incrementCounter() {
        d.x = (UInt32(littleEndian: d.x) &+ 1).littleEndian
        if d.x == 0 {
            d.y = (UInt32(littleEndian: d.y) &+ 1).littleEndian
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
}

fileprivate extension SIMD4 where Scalar == UInt32 {
    @inline(__always)
    var littleEndian: Self {
        Self(x.littleEndian, y.littleEndian, z.littleEndian, w.littleEndian)
    }
    
    @inline(__always)
    mutating func rotate(left count: UInt32) {
        self = (self &<< count) | (self &>> (32 - count))
    }
}
