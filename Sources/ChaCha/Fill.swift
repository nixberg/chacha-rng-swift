import Collections
import EndianBytes

public protocol FillingRandomNumberGenerator {
    mutating func fill(_ buffer: UnsafeMutableRawBufferPointer)
    
    mutating func fill<Output>(_ output: inout Output)
    where Output: MutableCollection, Output.Element: FixedWidthInteger & UnsignedInteger
}

extension ChaCha: FillingRandomNumberGenerator {
    public mutating func fill(_ buffer: UnsafeMutableRawBufferPointer) {
        var word: UInt32 = 0
        var count = 0
        
        for i in buffer.indices {
            if count.isMultiple(of: 4) {
                word = self.next()
            }
            
            buffer[i] = UInt8(truncatingIfNeeded: word)
            
            word >>= 8
            count += 1
        }
    }
    
    public mutating func fill<Output>(_ output: inout Output)
    where Output: MutableCollection, Output.Element: FixedWidthInteger & UnsignedInteger {
        if output.withContiguousMutableStorageIfAvailable({
            self.fill(UnsafeMutableRawBufferPointer($0))
        }) != nil {
            return
        }
        
        switch Output.Element.bitWidth {
        case let bitWidth where bitWidth.isMultiple(of: 8):
            var buffer: Deque<UInt8> = []
            
            for i in output.indices {
                while buffer.count < (Output.Element.bitWidth / 8) {
                    let word: UInt32 = self.next()
                    buffer.append(contentsOf: word.littleEndianBytes())
                }
                
                output[i] = .init(littleEndianBytes: buffer.prefix(Output.Element.bitWidth / 8))!
                buffer.removeFirst(Output.Element.bitWidth / 8)
            }
        default:
            preconditionFailure("Most general case not implemented; Maybe use BitArray.")
        }
    }
    
    // TODO: Float16
    
    public mutating func fill<Output>(_ output: inout Output)
    where Output: MutableCollection, Output.Element == Float32 {
        for i in output.indices {
            output[i] = self.next()
        }
    }
    
    public mutating func fill<Output>(_ output: inout Output)
    where Output: MutableCollection, Output.Element == Float64 {
        for i in output.indices {
            output[i] = self.next()
        }
    }
}
