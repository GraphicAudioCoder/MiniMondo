import MetalKit

class Renderer: NSObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    static var time: NSTextField!
    static var killedLabel: NSTextField!
    
    let depthStencilState: MTLDepthStencilState?
    
    var clock = 60
    var params = Params()
    var uniforms = Uniforms()
    
    var countdown: Int = 60 {
        didSet {
            Renderer.time.stringValue = String(countdown)
            
            if countdown <= 0 {
                // Fai qualcosa quando il timer raggiunge 0 (es. ferma il conto alla rovescia)
                // countdown = 60 // Per riavviare il conto alla rovescia, se necessario
            }
        }
    }
    
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
        
        
        let imageView = NSImageView()
        metalView.addSubview(imageView)
        
        if let image = NSImage(named: "mirino") {
            imageView.image = image
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 200),  // Imposta la larghezza desiderata
            imageView.heightAnchor.constraint(equalToConstant: 200), // Imposta l'altezza desiderata
            imageView.centerXAnchor.constraint(equalTo: metalView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: metalView.centerYAnchor),
        ])
        
        Renderer.time = NSTextField()
        Renderer.time.stringValue = String(clock)
        Renderer.time.isEditable = false
        Renderer.time.isBezeled = false
        Renderer.time.drawsBackground = false
        if let customFont = NSFont(name: "Helvetica Neue", size: 40) {
            Renderer.time.font = customFont
        }
        Renderer.time.textColor = NSColor.red
        
        metalView.addSubview(Renderer.time)
        
        Renderer.time.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            Renderer.time.centerXAnchor.constraint(equalTo: metalView.centerXAnchor),
            Renderer.time.topAnchor.constraint(equalTo: metalView.topAnchor, constant: 20)
        ])
        
        Renderer.killedLabel = NSTextField()
        Renderer.killedLabel.stringValue = "0"
        Renderer.killedLabel.isEditable = false
        Renderer.killedLabel.isBezeled = false
        Renderer.killedLabel.drawsBackground = false
        if let customFont = NSFont(name: "Helvetica Neue", size: 30) {
            Renderer.killedLabel.font = customFont
        }
        Renderer.killedLabel.textColor = NSColor.red
        
        metalView.addSubview(        Renderer.killedLabel)
        
        Renderer.killedLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            Renderer.killedLabel.leadingAnchor.constraint(equalTo: metalView.leadingAnchor, constant: 20),
            Renderer.killedLabel.topAnchor.constraint(equalTo: metalView.topAnchor, constant: 10)
        ])
        
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
        params.lightCount = UInt32(scene.lighting.lights.count)
        params.cameraPosition = scene.camera.position
    }
    
    func draw(scene: GameScene, in view: MTKView) {
        guard countdown > 0 else {
            return
        }
        
        guard let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
              let descriptor = view.currentRenderPassDescriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else { return }
        
        updateUniforms(scene: scene)
        renderEncoder.setDepthStencilState(depthStencilState)
        var lights = scene.lighting.lights
        renderEncoder.setFragmentBytes(
            &lights,
            length: MemoryLayout<Light>.stride * lights.count,
            index: LightBuffer.index)
        
        for model in scene.models {
            model.render(
                encoder: renderEncoder,
                uniforms: uniforms,
                params: params)
        }
        clock += 1
        if clock % 60 == 0 {
            countdown -= 1
        }
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable
        else { return }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
