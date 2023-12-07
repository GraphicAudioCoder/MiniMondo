import MetalKit

struct FPCamera: Camera {
    var models: [GameObject] = []
    
    var target: float3 = [0.0, 0.0, 0.0]
    var distance: Float = 0.0
    var transform = Transform()
    var aspect: Float = 1.0
    var fov = Float(70).degreesToRadians
    var near: Float = 0.1
    var far: Float = 100
    mutating func hideCursor() {}
    mutating func showCursor() {}
    
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
        (float4x4(translation: position) *
         float4x4(rotation: rotation)).inverse
    }
    
    mutating func update(deltaTime: Float) {
        let transform = updateInput(deltaTime: deltaTime)
        rotation += transform.rotation
        position += transform.position
    }
}

extension FPCamera: Movement { }
