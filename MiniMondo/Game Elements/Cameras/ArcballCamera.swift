import MetalKit

struct ArcballCamera: Camera {
    var models: [GameObject] = []
    
    var transform = Transform()
    var aspect: Float = 1.0
    var fov = Float(70).degreesToRadians
    var near: Float = 0.1
    var far: Float = 100
    mutating func hideCursor() {}
    mutating func showCursor() {}
    
    let minDistance: Float = 0.0
    let maxDistance: Float = 20
    var target: float3 = [0, 0, 0]
    var distance: Float = 2.5
    
    var projectionMatrix: float4x4 {
        float4x4(
            projectionFov: fov,
            near: near,
            far: far,
            aspect: aspect)
    }
    
    mutating func update(size: CGSize) {
        aspect = Float(size.width / size.height)
    }
    
    var viewMatrix: float4x4 {
        let matrix: float4x4
        if target == position {
            matrix = (float4x4(translation: target) * float4x4(rotationYXZ: rotation)).inverse
        } else {
            matrix = float4x4(eye: position, center: target, up: [0, 1, 0])
        }
        return matrix
    }
    
    var targetDistance: Float = 2.5
    var zoomVelocity: Float = 0.0
    let zoomAcceleration: Float = 5.0 // Puoi sperimentare con questo valore
    
    mutating func update(deltaTime: Float) {
        let input = InputController.shared
        let scrollSensitivity = Settings.mouseScrollSensitivity
        let zoomDelta = (input.mouseScroll.x + input.mouseScroll.y) * scrollSensitivity
        
        // Applica accelerazione alla variazione di zoom
        zoomVelocity += zoomDelta * zoomAcceleration * deltaTime
        
        // Applica una piccola smoothing alla velocità dello zoom
        let zoomSmoothingFactor: Float = 5.0
        zoomVelocity += (0.0 - zoomVelocity) * deltaTime * zoomSmoothingFactor
        
        // Imposta una soglia minima per evitare lo "scattino" finale
        let minZoomDelta: Float = 0.01
        if abs(zoomVelocity) > minZoomDelta {
            targetDistance -= zoomVelocity
            targetDistance = min(max(targetDistance, minDistance), maxDistance)
            input.mouseScroll = .zero
        }
        
        // Applica uno smoothing per una transizione più graduale
        let smoothingFactor: Float = 10.0
        distance += (targetDistance - distance) * deltaTime * smoothingFactor
        
        if input.leftMouseDown {
            let sensitivity = Settings.mousePanSensitivity
            rotation.x += input.mouseDelta.y * sensitivity
            rotation.y += input.mouseDelta.x * sensitivity
            rotation.x = max(-.pi / 2, min(rotation.x, .pi / 2))
            input.mouseDelta = .zero
        }
        
        let rotateMatrix = float4x4(rotationYXZ: [-rotation.x, rotation.y, 0])
        let distanceVector = float4(0, 0, -distance, 0)
        let rotatedVector = rotateMatrix * distanceVector
        position = target + rotatedVector.xyz
    }
}
