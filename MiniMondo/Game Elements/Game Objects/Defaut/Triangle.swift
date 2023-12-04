import MetalKit

class Triangle: DefaultModel {
    let defaultPipeline: BasicRenderPipeline!
    
    init(scale: Float = 1) {
        let vertices: [Float] = [
            0,  1,  0,
            -1, -1,  0,
            1, -1,  0
        ]
        
        let indices: [UInt16] = [
            0, 1, 2
        ]
        
        let colors: [simd_float3] = [
            Color.shared.getColor(for: .red),
            Color.shared.getColor(for: .green),
            Color.shared.getColor(for: .blue)
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
