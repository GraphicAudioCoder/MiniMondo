import MetalKit

struct BasicColor {
    let rgb: simd_float3
    let clearColor: MTLClearColor
}

class Colors {
    static let shared = Colors()
    
    private init() {}
    
    enum Palette {
        case red
        case green
        case blue
        case yellow
        case purple
        case orange
        case white
        case black
        case spolvero
        case whiteBack
    }
    
    private let colorMap: [Palette: BasicColor] = [
        .red: BasicColor(rgb: simd_float3(1.0, 0.0, 0.0), clearColor: MTLClearColorMake(1.0, 0.0, 0.0, 1.0)),
        .green: BasicColor(rgb: simd_float3(0.0, 1.0, 0.0), clearColor: MTLClearColorMake(0.0, 1.0, 0.0, 1.0)),
        .blue: BasicColor(rgb: simd_float3(0.0, 0.0, 1.0), clearColor: MTLClearColorMake(0.0, 0.0, 1.0, 1.0)),
        .yellow: BasicColor(rgb: simd_float3(1.0, 1.0, 0.0), clearColor: MTLClearColorMake(1.0, 1.0, 0.0, 1.0)),
        .purple: BasicColor(rgb: simd_float3(0.5, 0.0, 0.5), clearColor: MTLClearColorMake(0.5, 0.0, 0.5, 1.0)),
        .orange: BasicColor(rgb: simd_float3(1.0, 0.5, 0.0), clearColor: MTLClearColorMake(1.0, 0.5, 0.0, 1.0)),
        .white: BasicColor(rgb: simd_float3(1.0, 1.0, 1.0), clearColor: MTLClearColorMake(1.0, 1.0, 1.0, 1.0)),
        .black: BasicColor(rgb: simd_float3(0.0, 0.0, 0.0), clearColor: MTLClearColorMake(0.0, 0.0, 0.0, 1.0)),
        .whiteBack: BasicColor(rgb: simd_float3(0.93, 0.97, 1.0), clearColor: MTLClearColorMake(0.93, 0.97, 1.0, 1.0)),
        .spolvero: BasicColor(rgb: simd_float3(1.0, 1.0, 0.8), clearColor: MTLClearColorMake(1.0, 1.0, 0.8, 1.0))
    ]
    
    func getColor(for palette: Palette) -> simd_float3 {
        return colorMap[palette]?.rgb ?? simd_float3(0.0, 0.0, 0.0)
    }
    
    func getClearColor(for palette: Palette) -> MTLClearColor {
        return colorMap[palette]?.clearColor ?? MTLClearColorMake(0.0, 0.0, 0.0, 1.0)
    }
}
