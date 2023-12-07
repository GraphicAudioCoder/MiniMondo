import MetalKit

class GizmoSphereScene: GameScene {
    
    var gizmo: GameObject!
    var sphere: GameObject!
    
    var defaultView: Transform {
      Transform(
        position: [-1.18, 1.57, -1.28],
        rotation: [-0.73, 13.3, 0.0])
    }
    
    override init() {
        super.init()
        lighting = GizmoSphereLighting()
        camera = ArcballCamera()
        camera.distance = 2.5
        camera.transform = defaultView
        sphere = Model(name: "sphere.obj")
        gizmo = Model(name: "gizmo.usd")
        
        models = [gizmo, sphere]
    }
    
    override func update(deltaTime: Float) {
        let input = InputController.shared
        if input.keysPressed.contains(.one) {
            camera.transform = Transform()
        }
        if input.keysPressed.contains(.two) {
            camera.transform = defaultView
        }
        super.update(deltaTime: deltaTime)
        calculateGizmo()
    }
    
    func calculateGizmo() {
        var forwardVector: float3 {
            let lookat = float4x4(eye: camera.position, center: .zero, up: [0, 1, 0])
            return [
                lookat.columns.0.z, lookat.columns.1.z, lookat.columns.2.z
            ]
        }
        var rightVector: float3 {
            let lookat = float4x4(eye: camera.position, center: .zero, up: [0, 1, 0])
            return [
                lookat.columns.0.x, lookat.columns.1.x, lookat.columns.2.x
            ]
        }
        
        let heightNear = 2 * tan(camera.fov / 2) * camera.near
        let widthNear = heightNear * camera.aspect
        let cameraNear = camera.position + forwardVector * camera.near
        let cameraUp = float3(0, 1, 0)
        let bottomLeft = cameraNear - (cameraUp * (heightNear / 2)) - (rightVector * (widthNear / 2))
        gizmo.position = bottomLeft
        gizmo.position = (forwardVector - rightVector) * 10
    }
}
