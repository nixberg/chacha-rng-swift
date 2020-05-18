import XCTest
import ChaCha

final class ChaChaTests: XCTestCase {
    func testChaCha8() {
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
    
    func testNextUInt8() {
        var rng = ChaCha(rounds: .twenty, seed: .zero)
        
        let expected: [UInt8] = [
            0x76, 0xa0, 0x40, 0x53, 0xbd, 0xa0, 0xa8, 0x8b, 0xda, 0x51, 0x77, 0xb8, 0x6a, 0x15,
            0xc3, 0xb2, 0x9f, 0x55, 0x98, 0x73, 0xcb, 0x48, 0x12, 0x32, 0x29, 0x9c, 0xd5, 0x74,
            0x31, 0x51, 0xac, 0x4b, 0x2d, 0x63, 0xae, 0x19, 0x8e, 0x7b, 0xb0, 0xa9, 0x01, 0x1f,
            0x28, 0xe4, 0x73, 0xc9, 0x5f, 0x40, 0x13, 0xd7, 0xd5, 0x3e, 0xc5, 0xfb, 0xc3, 0xb4,
            0x2d, 0xf8, 0xed, 0x10, 0x1f, 0x6d, 0xe8, 0x31, 0xe5, 0x2b, 0xfb, 0x76, 0xe5, 0x1c,
            0xca, 0x8b, 0x4e, 0x90, 0x16, 0x83, 0x86, 0x57, 0xed, 0xfa, 0xe0, 0x9c, 0xb9, 0xa7,
            0x1e, 0xb2, 0x19, 0x02, 0x5c, 0x4c, 0x87, 0xa6, 0x7c, 0x4a, 0xaa, 0x86, 0xf2, 0x0a,
            0xc0, 0xaa, 0x79, 0x2b, 0xc1, 0x21, 0xee, 0x42, 0xe2, 0xc3, 0x26, 0x12, 0x70, 0x61,
            0xed, 0xa1, 0x55, 0x99, 0xcb, 0x5d, 0xb3, 0xdb, 0x87, 0x0b, 0xea, 0x5a, 0xec, 0xf3,
            0x53, 0x16
        ];
        
        XCTAssertEqual(expected.map { _ in rng.next() }, expected)
    }
    
    func testNextUInt16() {
        var rng = ChaCha(rounds: .twenty, seed: .zero)
        
        let expected: [UInt16] = [
            0xb876, 0xf1a0, 0x5d40, 0x8653, 0xd2bd, 0x8da0, 0x36a8, 0x778b, 0x41da, 0x5751, 0x2477,
            0xd8b8, 0x436a, 0x1815, 0x87c3, 0xeeb2, 0x079f, 0x5155, 0xba98, 0x2d73, 0x0fcb, 0xe348,
            0xc612, 0xee32, 0xb729, 0xe69c, 0x71d5, 0xd874, 0xed31, 0x0a51, 0xe1ac, 0x794b, 0x092d,
            0x2663, 0x7eae, 0x6819, 0x718e, 0xd37b, 0xc3b0, 0xa0a9, 0x2701, 0x7b1f, 0x1e28, 0x58e4,
            0xd273, 0xcfc9, 0xf35f, 0xa240, 0x2013, 0xb3d7, 0x20d5, 0xd23e, 0xb8c5, 0x85fb, 0x63c3,
            0x5cb4, 0xd42d, 0x84f8, 0xb1ed, 0x6210, 0x2c1f, 0xcd6d, 0x6ae8, 0x6731
        ];
        
        XCTAssertEqual(expected.map { _ in rng.next() }, expected)
    }
    
    func testNextUInt32() {
        var rng = ChaCha(rounds: .twenty, seed: .zero)
        
        let expected: [UInt32] = [
            0xade0b876, 0x903df1a0, 0xe56a5d40, 0x28bd8653, 0xb819d2bd, 0x1aed8da0, 0xccef36a8,
            0xc70d778b, 0x7c5941da, 0x8d485751, 0x3fe02477, 0x374ad8b8, 0xf4b8436a, 0x1ca11815,
            0x69b687c3, 0x8665eeb2, 0xbee7079f, 0x7a385155, 0x7c97ba98, 0x0d082d73, 0xa0290fcb,
            0x6965e348, 0x3e53c612, 0xed7aee32, 0x7621b729, 0x434ee69c, 0xb03371d5, 0xd539d874,
            0x281fed31, 0x45fb0a51, 0x1f0ae1ac, 0x6f4d794b
        ];
        
        XCTAssertEqual(expected.map { _ in rng.next() }, expected)
    }
    
    func testNextUInt64() {
        var rng = ChaCha(rounds: .twenty, seed: .zero)
        
        let expected: [UInt64] = [
            0x903df1a0ade0b876, 0x28bd8653e56a5d40, 0x1aed8da0b819d2bd, 0xc70d778bccef36a8,
            0x8d4857517c5941da, 0x374ad8b83fe02477, 0x1ca11815f4b8436a, 0x8665eeb269b687c3,
            0x7a385155bee7079f, 0x0d082d737c97ba98, 0x6965e348a0290fcb, 0xed7aee323e53c612,
            0x434ee69c7621b729, 0xd539d874b03371d5, 0x45fb0a51281fed31, 0x6f4d794b1f0ae1ac
        ];
        
        XCTAssertEqual(expected.map { _ in rng.next() }, expected)
    }
    
    func testNextFloat32() {
        var rng = ChaCha(rounds: .twenty, seed: .zero)
        
        let expected: [Float32] = [
            0.679210186, 0.563445151, 0.896154225, 0.159141898, 0.719143987, 0.105187237,
            0.800525069, 0.777549207, 0.485736907, 0.551885068, 0.249513865, 0.215985775,
            0.955936611, 0.111833096, 0.412941396, 0.524992824, 0.745712698, 0.477421820,
            0.486690164, 0.050906003, 0.625626504, 0.411710918, 0.243465781, 0.927657008,
            0.461451948, 0.262922645, 0.688284934, 0.832913876, 0.156737149, 0.273361802,
            0.121259749, 0.434775889
        ];
        
        XCTAssertEqual(expected.map { _ in rng.next() }, expected)
    }
    
    func testNextFloat64() {
        var rng = ChaCha(rounds: .twenty, seed: .zero)
        
        let expected: [Float64] = [
            0.56344518826324730, 0.15914191768880792, 0.10518727468306754, 0.77754923976038692,
            0.55188508738897202, 0.21598581789282933, 0.11183310066255192, 0.52499286514076893,
            0.47742184012795619, 0.05090602941035527, 0.41171093485914778, 0.92765701986929994,
            0.26292268104419381, 0.83291390274844246, 0.27336182099691053, 0.43477590641036157
        ];
        
        XCTAssertEqual(expected.map { _ in rng.next() }, expected)
    }
    
    func testStream() {
        var rng = ChaCha(rounds: .twenty, seed: .zero, stream: 0xb61e6e6a48c285)
        
        let expected: [UInt32] = [
            0x3fa865f8, 0xcc53c4a6, 0xe1a9bb4a, 0x321a1962, 0xfa0d984f, 0x1073a4d4, 0xbcc96d46,
            0x34844c3c, 0xb517199b, 0xde11cc87, 0x2c73cbfa, 0x194204f9, 0x4d71451e, 0xd5d7b9a7,
            0xa3eb1a0b, 0x5b17ee8a, 0x654c6867, 0x8282050c, 0x325604f6, 0x13c681b8, 0xfc1bddcc,
            0x93c1299e, 0x6ae1f5c3, 0x7915dfad, 0xbe635958, 0x878e07d8, 0x1b9437ff, 0x1611b826,
            0xc0f16fe1, 0x831520c6, 0xa7570c72, 0x700b6066
        ]
        
        var array = [UInt32](repeating: 0, count: 32)
        rng.fill(&array[...])
        
        XCTAssertEqual(array, expected)
    }
}
