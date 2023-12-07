import MetalKit

class GameTestSceneOneCube: GameScene {
    lazy var cube = Model(name: "cube.obj")
    var currentDirection: float3 = float3(1, 0, 0) // Inizializza con una direzione casuale
    let movementSpeed: Float = 5.0
    let maxDistance: Float = 3.0 // Modifica a seconda delle tue esigenze
    var distanceTraveled: Float = 0.0
    var clock: Float = 0.0

    override init() {
        super.init()
        lighting = BackyardHouseLighting()
        camera = PlayerCamera()
        //        camera.hideCursor()
        
        camera.position = [0, 1.5, -5]
        
        let house = Model(name: "lowpoly-house.obj")
        models.append(house)
        let ground: GameObject = {
            var ground = Model(name: "plane.obj")
            ground.tiling = 16
            ground.scale = 40
            return ground
        }()
        models.append(ground)
        cube = Model(name: "cube.obj")
        cube.position.y = 4
        cube.position.x = 4
        cube.scale = 0.25
        models.append(cube)
    
    }
    
    override func update(deltaTime: Float) {
        super.update(deltaTime: deltaTime)
        
        cube.rotation.x += deltaTime
        cube.rotation.y += deltaTime
        clock += 1
        
        // Muovi il cubo nella direzione corrente
        cube.position += currentDirection * movementSpeed * deltaTime
        distanceTraveled += movementSpeed * deltaTime
        cube.position.y += sin(clock) * deltaTime
        //        cube.position.y += currentDirection.y * movementSpeed * deltaTime
        
        // Se hai superato la soglia, cambia direzione
        if distanceTraveled > maxDistance {
            distanceTraveled = 0.0
            currentDirection = getRandomDirection()
        }
        
        let input = InputController.shared
        guard let camera = camera as? PlayerCamera else {
            return
        }
        
        let viewMatrix = camera.viewMatrix
        let cubePositionInView = viewMatrix * float4(cube.position, 1.0)
        let centerThreshold: Float = 0.5
        if abs(cubePositionInView.x) < centerThreshold && abs(cubePositionInView.y) < centerThreshold {
            if input.leftMouseDown {
                print("Centro")
            }
        } else { }
    }
    
    func getRandomDirection() -> SIMD3<Float> {
        // Return a normalized random direction
        return SIMD3<Float>(Float.random(in: -1...1), 0, Float.random(in: -1...1))
    }
    
}
