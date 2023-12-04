import MetalKit

protocol RenderPipeline {
    var pipelineState: MTLRenderPipelineState { get }
    func set(renderEncoder: MTLRenderCommandEncoder)
}

