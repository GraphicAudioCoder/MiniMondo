import MetalKit

class CartoonCottageScene: GameScene {
    override init() {
        super.init()
        lighting = CartoonCottageLighting()
        camera = ArcballCamera()
        
//        let cottage = Model(name: "cottage1.obj")
        let cottage = Model(name: "cube.obj")
        camera.target = [0, 2.2, 0]
        camera.transform = Transform(
            position: [4.6, 2.3, -3.84],
            rotation: [-0.05, 11.7, 0.0])

        models = [cottage]
    }
}

