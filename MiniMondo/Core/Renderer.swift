import MetalKit

class Renderer: NSObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    
    let depthStencilState: MTLDepthStencilState?

    var params = Params()
    var uniforms = Uniforms()
    
    init(metalView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue()
        else { fatalError("GPU not available") }
        Renderer.device = device
        Renderer.commandQueue = commandQueue
        metalView.device = device
        metalView.depthStencilPixelFormat = Preferences.depthPixelFormat
        let library = device.makeDefaultLibrary()
        Renderer.library = library
        depthStencilState = Renderer.buildDepthStencilState()
        
        super.init()
        metalView.clearColor = Colors.shared.getClearColor(for: .whiteBack)
    }
    
    static func buildDepthStencilState() -> MTLDepthStencilState? {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true
        return Renderer.device.makeDepthStencilState(descriptor: descriptor)
    }
}

extension Renderer {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    
    func updateUniforms(scene: GameScene) {
      uniforms.viewMatrix = scene.camera.viewMatrix
      uniforms.projectionMatrix = scene.camera.projectionMatrix
    }
    
    func draw(scene: GameScene, in view: MTKView) {
        guard let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
              let descriptor = view.currentRenderPassDescriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else { return }
        
        updateUniforms(scene: scene)
        renderEncoder.setDepthStencilState(depthStencilState)
        for model in scene.models {
          model.render(
            encoder: renderEncoder,
            uniforms: uniforms,
            params: params)
        }
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable
        else { return }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
