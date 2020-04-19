import XCTest
@testable import ChaCha

final class ChaChaTests: XCTestCase {
    func testChaCha() {
        var rng = ChaCha(rounds: .twenty, seed: .zero)
        
        let vectors: [[UInt32]] = [
            [
                0xade0b876, 0x903df1a0, 0xe56a5d40, 0x28bd8653,
                0xb819d2bd, 0x1aed8da0, 0xccef36a8, 0xc70d778b,
                0x7c5941da, 0x8d485751, 0x3fe02477, 0x374ad8b8,
                0xf4b8436a, 0x1ca11815, 0x69b687c3, 0x8665eeb2
            ],
            [
                0xbee7079f, 0x7a385155, 0x7c97ba98, 0x0d082d73,
                0xa0290fcb, 0x6965e348, 0x3e53c612, 0xed7aee32,
                0x7621b729, 0x434ee69c, 0xb03371d5, 0xd539d874,
                0x281fed31, 0x45fb0a51, 0x1f0ae1ac, 0x6f4d794b
            ]
        ]
        
        for vector in vectors {
            XCTAssertEqual(vector.indices.map { _ in rng.next() }, vector)
        }
    }
    
    func testRandomNumberGenerator() {
        var rng = ChaCha(seed: .zero)
        
        for _ in 0..<3_141 {
            let _ = rng.next() as UInt64
        }
        
        let vector: SIMD8<UInt64> = [
            0x0fee22eda2aa9ad4, 0x1777d0b16de665f8,
            0xd5982a26db1ab427, 0x258c713d160030fb,
            0xe46846b5a485a788, 0x5b17880e52a4bf6f,
            0xff7ae1b1f77ad022, 0xd161b85f84bd6b21
        ]
        
        XCTAssertEqual(.random(in: 0...UInt64.max, using: &rng), vector)
    }
}
