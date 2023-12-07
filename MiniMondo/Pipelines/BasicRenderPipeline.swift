import MetalKit

class BasicRenderPipeline: RenderPipeline {
    var pipelineState: MTLRenderPipelineState
    
    init(device: MTLDevice, vertexFunction: String, fragmentFunction: String, colorPixelFormat: MTLPixelFormat, vertexDescriptor: MTLVertexDescriptor) {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = Renderer.library.makeFunction(name: vertexFunction)
        pipelineDescriptor.fragmentFunction = Renderer.library.makeFunction(name: fragmentFunction)
        pipelineDescriptor.colorAttachments[0].pixelFormat = colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = Preferences.depthPixelFormat
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error { fatalError(error.localizedDescription) }
    }
    
    func set(renderEncoder: MTLRenderCommandEncoder) {
        renderEncoder.setRenderPipelineState(pipelineState)
    }
}
