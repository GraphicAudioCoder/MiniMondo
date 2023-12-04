import MetalKit

class GameObject: Transformable {
    var name: String
    var renderPipeline: MTLRenderPipelineState
    var transform = Transform()
    var tiling: UInt32 = 1

    init(name: String, renderPipeline: MTLRenderPipelineState) {
        self.name = name
        self.renderPipeline = renderPipeline
    }
    
    func render(encoder: MTLRenderCommandEncoder, uniforms vertex: Uniforms, params fragment: Params) { }
}
