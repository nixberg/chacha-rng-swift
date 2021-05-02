public extension ChaCha {
    mutating func fill(_ slice: inout ArraySlice<UInt8>) {
        for i in stride(from: slice.startIndex, through: slice.endIndex, by: 4).dropLast() {
            let word: UInt32 = self.next()
            slice[i + 0] = UInt8(truncatingIfNeeded: word)
            slice[i + 1] = UInt8(truncatingIfNeeded: word >> 8)
            slice[i + 2] = UInt8(truncatingIfNeeded: word >> 16)
            slice[i + 3] = UInt8(truncatingIfNeeded: word >> 24)
        }
        
        if !slice.count.isMultiple(of: 4) {
            var word: UInt32 = self.next()
            for i in slice.indices.suffix(slice.count % 4) {
                slice[i] = UInt8(truncatingIfNeeded: word)
                word >>= 8
            }
        }
    }
    
    mutating func fill(_ slice: inout ArraySlice<UInt16>) {
        for i in stride(from: slice.startIndex, through: slice.endIndex, by: 2).dropLast() {
            let word: UInt32 = self.next()
            slice[i + 0] = UInt16(truncatingIfNeeded: word)
            slice[i + 1] = UInt16(truncatingIfNeeded: word >> 16)
        }
        
        if !slice.count.isMultiple(of: 2) {
            let word: UInt32 = self.next()
            slice[slice.index(before: slice.endIndex)] = UInt16(truncatingIfNeeded: word)
        }
    }
    
    mutating func fill(_ slice: inout ArraySlice<UInt32>) {
        for i in slice.indices {
            slice[i] = self.next()
        }
    }
    
    mutating func fill(_ slice: inout ArraySlice<UInt64>) {
        for i in slice.indices {
            slice[i] = self.next()
        }
    }
    
    mutating func fill(_ slice: inout ArraySlice<Float32>) {
        for i in slice.indices {
            slice[i] = self.next()
        }
    }
    
    mutating func fill(_ slice: inout ArraySlice<Float64>) {
        for i in slice.indices {
            slice[i] = self.next()
        }
    }
}
