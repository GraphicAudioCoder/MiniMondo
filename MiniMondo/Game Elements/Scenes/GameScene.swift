import MetalKit

class GameScene {
    var camera = Debug3DCamera()
    
    lazy var house: GameObject = Model(name: "lowpoly-house.obj")
    lazy var ground: GameObject = {
        var ground = Model(name: "plane.obj")
        ground.tiling = 16
        ground.scale = 40
        return ground
    }()
    lazy var models: [GameObject] = [ground, house]
    
    init() {
//        camera.hideCursor()
        camera.position = [0, 1.5, -5]
    }
    
    func update(size: CGSize) {
        camera.update(size: size)
    }
    
    func update(deltaTime: Float) {
        camera.update(deltaTime: deltaTime)
    }
}
