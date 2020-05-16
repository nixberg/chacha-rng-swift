extension ChaCha {
    mutating func fill(_ slice: inout ArraySlice<UInt8>) {
        let tailCount = slice.count % 4
        
        for i in stride(from: slice.startIndex, to: slice.endIndex - tailCount, by: 4) {
            let word: UInt32 = self.next()
            slice[i + 0] = UInt8(truncatingIfNeeded: word)
            slice[i + 1] = UInt8(truncatingIfNeeded: word &>> 8)
            slice[i + 2] = UInt8(truncatingIfNeeded: word &>> 16)
            slice[i + 3] = UInt8(truncatingIfNeeded: word &>> 24)
        }
        
        if tailCount > 0 {
            var word: UInt32 = self.next()
            for i in slice.indices.suffix(tailCount) {
                slice[i] = UInt8(truncatingIfNeeded: word)
                word &>>= 8
            }
        }
    }
    
    mutating func fill(_ slice: inout ArraySlice<UInt16>) {
        let tailCount = slice.count % 2
        
        for i in stride(from: slice.startIndex, to: slice.endIndex - tailCount, by: 2) {
            let word: UInt32 = self.next()
            slice[i + 0] = UInt16(truncatingIfNeeded: word)
            slice[i + 1] = UInt16(truncatingIfNeeded: word &>> 16)
        }
        
        if tailCount > 0 {
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
}
