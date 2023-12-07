import MetalKit

class GameScene {
    var camera: Camera!
    
    lazy var models: [GameObject] = []
    lazy var lighting = SceneLighting()
    
    init() { }
    
    func update(size: CGSize) {
        camera.update(size: size)
    }
    
    func update(deltaTime: Float) {
        camera.update(deltaTime: deltaTime)
    }
}
