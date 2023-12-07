import MetalKit

class Quad: DefaultModel {
    let defaultPipeline: BasicRenderPipeline!
    
    init(scale: Float = 1) {
        let vertices: [Float] = [
            -1,  1,  0,
             1,  1,  0,
             -1, -1,  0,
             1, -1,  0
        ]
        
        let indices: [UInt16] = [
            0, 3, 2,
            0, 1, 3
        ]
        
        let colors: [simd_float3] = [
            Colors.shared.getColor(for: .red),
            Colors.shared.getColor(for: .green),
            Colors.shared.getColor(for: .blue),
            Colors.shared.getColor(for: .yellow)
        ]
        
        defaultPipeline = BasicRenderPipeline(device: Renderer.device,
                                              vertexFunction: "vertex_main_default_model",
                                              fragmentFunction: "fragment_main_default_model",
                                              colorPixelFormat: Preferences.colorPixelFormat,
                                              vertexDescriptor: MTLVertexDescriptor.defaultLayout)
        
        super.init(name: "Triangle",
                   renderPipeline: defaultPipeline.pipelineState,
                   vertices: vertices,
                   indices: indices,
                   colors: colors,
                   device: Renderer.device,
                   scale: scale)
    }
    
    override func render(encoder: MTLRenderCommandEncoder, uniforms vertex: Uniforms, params fragment: Params) {
        encoder.setRenderPipelineState(defaultPipeline.pipelineState)
        super.render(encoder: encoder, uniforms: vertex, params: fragment)
        encoder.setVertexBuffer(
            vertexBuffer,
            offset: 0,
            index: 0)
        encoder.setVertexBuffer(
            colorBuffer,
            offset: 0,
            index: 1)
        
        encoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: indices.count,
            indexType: .uint16,
            indexBuffer: indexBuffer,
            indexBufferOffset: 0)
    }
}
