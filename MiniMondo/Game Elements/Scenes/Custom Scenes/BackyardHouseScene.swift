import MetalKit

class BackyardHouseScene: GameScene {
    override init() {
        super.init()
        camera.position = [0, 1.5, -5]
        let house = Model(name: "lowpoly-house.obj")
        let ground: GameObject = {
            var ground = Model(name: "plane.obj")
            ground.tiling = 16
            ground.scale = 40
            return ground
        }()
        
        models = [ground, house]
    }
}
