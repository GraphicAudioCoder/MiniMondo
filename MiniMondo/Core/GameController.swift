import MetalKit

class GameController: NSObject {
    var renderer: Renderer!
    var scene: GameScene
    var fps: Double = 0
    var deltaTime: Double = 0
    var lastTime: Double = CFAbsoluteTimeGetCurrent()
    
    init(metalView: MTKView) {
        renderer = Renderer(metalView: metalView)
        scene = Setup.currentScene
        super.init()
        metalView.delegate = self
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
        fps = Double(metalView.preferredFramesPerSecond)
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
    }
}

extension GameController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene.update(size: size)
        renderer.mtkView(view, drawableSizeWillChange: size)
    }
    
    func draw(in view: MTKView) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        let deltaTime = (currentTime - lastTime)
        lastTime = currentTime
        scene.update(deltaTime: Float(deltaTime))
        renderer.draw(scene: scene, in: view)
    }
}
