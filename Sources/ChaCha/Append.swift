public extension ChaCha {
    mutating func append<Output>(to output: inout Output, count: Int)
    where Output: RangeReplaceableCollection, Output.Element == UInt8 {
        for _ in stride(from: 0, through: count, by: 4).dropLast() {
            let word: UInt32 = self.next()
            output.append(UInt8(truncatingIfNeeded: word))
            output.append(UInt8(truncatingIfNeeded: word >> 8))
            output.append(UInt8(truncatingIfNeeded: word >> 16))
            output.append(UInt8(truncatingIfNeeded: word >> 24))
        }
        
        if !count.isMultiple(of: 4) {
            var word: UInt32 = self.next()
            for _ in 0..<(count % 4) {
                output.append(UInt8(truncatingIfNeeded: word))
                word >>= 8
            }
        }
    }
    
    mutating func generateArray(count: Int) -> [UInt8] {
        var output: [UInt8] = []
        output.reserveCapacity(count)
        self.append(to: &output, count: count)
        return output
    }
    
    mutating func append<Output>(to output: inout Output, count: Int)
    where Output: RangeReplaceableCollection, Output.Element == UInt16 {
        for _ in stride(from: 0, through: count, by: 2).dropLast() {
            let word: UInt32 = self.next()
            output.append(UInt16(truncatingIfNeeded: word))
            output.append(UInt16(truncatingIfNeeded: word >> 16))
        }
        
        if !count.isMultiple(of: 2) {
            let word: UInt32 = self.next()
            output.append(UInt16(truncatingIfNeeded: word))
        }
    }
    
    mutating func generateArray(count: Int) -> [UInt16] {
        var output: [UInt16] = []
        output.reserveCapacity(count)
        self.append(to: &output, count: count)
        return output
    }
    
    mutating func append<Output>(to output: inout Output, count: Int)
    where Output: RangeReplaceableCollection, Output.Element == UInt32 {
        for _ in 0..<count {
            output.append(self.next())
        }
    }
    
    mutating func generateArray(count: Int) -> [UInt32] {
        var output: [UInt32] = []
        output.reserveCapacity(count)
        self.append(to: &output, count: count)
        return output
    }
    
    mutating func append<Output>(to output: inout Output, count: Int)
    where Output: RangeReplaceableCollection, Output.Element == UInt64 {
        for _ in 0..<count {
            output.append(self.next())
        }
    }
    
    mutating func generateArray(count: Int) -> [UInt64] {
        var output: [UInt64] = []
        output.reserveCapacity(count)
        self.append(to: &output, count: count)
        return output
    }
    
    mutating func append<Output>(to output: inout Output, count: Int)
    where Output: RangeReplaceableCollection, Output.Element == Float32 {
        for _ in 0..<count {
            output.append(self.next())
        }
    }
    
    mutating func generateArray(count: Int) -> [Float32] {
        var output: [Float32] = []
        output.reserveCapacity(count)
        self.append(to: &output, count: count)
        return output
    }
    
    mutating func append<Output>(to output: inout Output, count: Int)
    where Output: RangeReplaceableCollection, Output.Element == Float64 {
        for _ in 0..<count {
            output.append(self.next())
        }
    }
    
    mutating func generateArray(count: Int) -> [Float64] {
        var output: [Float64] = []
        output.reserveCapacity(count)
        self.append(to: &output, count: count)
        return output
    }
}
