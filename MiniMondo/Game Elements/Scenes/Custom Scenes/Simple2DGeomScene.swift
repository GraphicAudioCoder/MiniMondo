import MetalKit

class Simple2DGeomScene: GameScene {
    override init() {
        super.init()
        lighting = Simple2DGeomLigthing()
        camera = Debug3DCamera()
        camera.position = [0, 1.5, -5]
        let ground: GameObject = {
            var ground = Model(name: "greenPlane.obj")
            ground.tiling = 32
            ground.scale = 40
            return ground
        }()
        var triangle = Triangle(scale: 1)
        var quad = Quad(scale: 1)
        triangle.position.x = -1.5
        triangle.position.z = -0.5
        quad.position.x = 1.5
        quad.position.z = 1.5
        
        models = [ground, triangle, quad]
    }
}
