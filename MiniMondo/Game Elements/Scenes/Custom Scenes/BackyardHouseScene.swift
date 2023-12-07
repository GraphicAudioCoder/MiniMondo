import MetalKit

class BackyardHouseScene: GameScene {
    override init() {
        super.init()
        lighting = BackyardHouseLighting()
        camera = PlayerCamera()
        camera.hideCursor()
        
        camera.position = [0, 1.5, -5]
//        var gun = Model(name: "M4.obj")
//        gun.scale = 0.03
//        gun.position = [0.3, 0.7, -4.7]
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
