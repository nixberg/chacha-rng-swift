public enum Rounds: Int {
    case eight = 8
    case twelve = 12
    case twenty = 20
}

public struct ChaCha: RandomNumberGenerator {
    public let rounds: Rounds
    
    private var state: State
    private var workingState: State = .zero
    private var wordIndex = 16
    
    public init(rounds: Rounds = .eight) {
        self.rounds = rounds
        state = State(.random(in: 0...UInt32.max), 0)
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
        
        defer {
            wordIndex += 1
        }
        
        return workingState[wordIndex]
    }
    
    public mutating func next() -> UInt64 {
        let low = UInt64(truncatingIfNeeded: self.next() as UInt32)
        let high = UInt64(truncatingIfNeeded: self.next() as UInt32)
        return (high &<< 32) | low
    }
    
    //public mutating func next() -> Float16 {
    //    Float16(self.next() as UInt16 &>> 5) * 0x1p-11
    //}
    
    public mutating func next() -> Float32 {
        Float32(self.next() as UInt32 &>> 8) * 0x1p-24
    }
    
    public mutating func next() -> Float64 {
        Float64(self.next() as UInt64 &>> 11) * 0x1p-53
    }
}

fileprivate typealias State = SIMD16<UInt32>

fileprivate extension State {
    @inline(__always)
    private var a: SIMD4<UInt32> {
        get { lowHalf.lowHalf }
        set { lowHalf.lowHalf = newValue }
    }
    
    @inline(__always)
    private var b: SIMD4<UInt32> {
        get { lowHalf.highHalf }
        set { lowHalf.highHalf = newValue }
    }
    
    @inline(__always)
    private var c: SIMD4<UInt32> {
        get { highHalf.lowHalf }
        set { highHalf.lowHalf = newValue }
    }
    
    @inline(__always)
    private var d: SIMD4<UInt32> {
        get { highHalf.highHalf }
        set { highHalf.highHalf = newValue }
    }
    
    init(_ seed: SIMD8<UInt32>, _ stream: UInt64) {
        self = SIMD16(
            lowHalf: SIMD8(
                lowHalf: SIMD4(0x61707865, 0x3320646e, 0x79622d32, 0x6b206574),
                highHalf: seed.lowHalf),
            highHalf: SIMD8(
                lowHalf: seed.highHalf,
                highHalf: SIMD4(0, 0, UInt32(truncatingIfNeeded: stream), UInt32(truncatingIfNeeded: stream &>> 32))
            )
        )
    }
    
    @inline(__always)
    mutating func incrementCounter() {
        self[12] &+= 1
        if self[12] == 0 {
            self[13] &+= 1
            precondition(self[13] != 0)
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
}

fileprivate extension SIMD4 where Scalar == UInt32 {
    @inline(__always)
    mutating func rotate(left count: UInt32) {
        self = (self &<< count) | (self &>> (32 - count))
    }
}
