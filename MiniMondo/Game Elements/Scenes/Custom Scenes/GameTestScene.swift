import MetalKit
import AVFoundation

class GameTestScene: GameScene {
    var currentDirection: float3 = float3(1, 0, 0)
    let movementSpeed: Float = 5.0
    let maxDistance: Float = 3.0
    var distanceTraveled: Float = 0.0
    var clock: Float = 0.0
    
    var targets: [Model] = []
    var currentDirections: [float3] = []
    let numCubes = 200
    let maxDistanceBetweenCubes: Float = 3.0
    
    var targetHitCount: [Int] = []
    let maxHitCount = 25
    var targetOffsetInModel = 0
    
    private var killedSound: AVAudioPlayer?
    
    override init() {
        super.init()
        lighting = BackyardHouseLighting()
        camera = PlayerCamera()
        camera.hideCursor()
        
        camera.position = [0, 1.5, -5]
        
        let house = Model(name: "lowpoly-house.obj")
        models.append(house)
        targetOffsetInModel += 1
        let ground: GameObject = {
            var ground = Model(name: "plane.obj")
            ground.tiling = 16
            ground.scale = 40
            return ground
        }()
        models.append(ground)
        targetOffsetInModel += 1
        
        for i in 0..<numCubes {
            var target = Model(name: "cube.obj")
            target.position.x = Float.random(in: -maxDistanceBetweenCubes...maxDistanceBetweenCubes)
            target.position.z = Float.random(in: -maxDistanceBetweenCubes...maxDistanceBetweenCubes)
            target.position.y = 4 + Float(i) / Float(numCubes) * 5.0
            target.scale = 0.25
            targetHitCount.append(0)
            targets.append(target)
            models.append(target)
        }
        
        for _ in 0..<numCubes {
            let direction = getRandomDirection()
            currentDirections.append(direction)
        }
        
    }
    
    override func update(deltaTime: Float) {
        super.update(deltaTime: deltaTime)
        
        for var target in targets {
            target.rotation.x += deltaTime
            target.rotation.y += deltaTime
        }
        
        clock += 1
        
        var count = 0
        for var target in targets {
            target.rotation.x += deltaTime
            target.rotation.y += deltaTime
            target.position += currentDirections[count] * movementSpeed * deltaTime
            target.position.y += sin(clock) * deltaTime
            count += 1
        }
        distanceTraveled += movementSpeed * deltaTime
        
        if distanceTraveled > maxDistance {
            distanceTraveled = 0.0
            count = 0
            for var direction in currentDirections {
                direction = getRandomDirection()
                currentDirections[count] = direction
                count += 1
            }
        }
        
        let input = InputController.shared
        guard let camera = camera as? PlayerCamera else {
            return
        }
        
        count = 0
        for target in targets {
            let viewMatrix = camera.viewMatrix
            let cubePositionInView = viewMatrix * float4(target.position, 1.0)
            let centerThreshold: Float = 0.5
            if abs(cubePositionInView.x) < centerThreshold && abs(cubePositionInView.y) < centerThreshold {
                if input.leftMouseDown {
                    print("Centro")
                    targetHitCount[count] += 1
                    // killed
                    if targetHitCount[count] >= maxHitCount {
                        models.remove(at: count + targetOffsetInModel)
                        targets.remove(at: count)
                        currentDirections.remove(at: count)
                        targetHitCount.remove(at: count)
                        var currentKill:Int! = Int(Renderer.killedLabel.stringValue)
                        currentKill += 1
                        Renderer.killedLabel.stringValue = String(currentKill)
                        count -= 1
                        playKilledSound()
                    }
                }
            }
            count += 1
        }
    }
    
    func getRandomDirection() -> SIMD3<Float> {
        return SIMD3<Float>(Float.random(in: -1...1), 0, Float.random(in: -1...1))
    }
    
    func playKilledSound() {
        guard let soundURL = Bundle.main.url(forResource: "killed", withExtension: "wav") else {
            print("Errore nel trovare il file audio walk.wav")
            return
        }
        
        do {
            killedSound = try AVAudioPlayer(contentsOf: soundURL)
            killedSound?.volume = 0.5
            killedSound?.prepareToPlay()
            killedSound?.play()
        } catch let error as NSError {
            print("Errore durante la riproduzione del suono: \(error.localizedDescription)")
        }
    }
}
