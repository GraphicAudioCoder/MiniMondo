import MetalKit

struct OrthographicCamera: Camera, Movement {
    var models: [GameObject] = []
    
    var target: float3 = [0.0, 0.0, 0.0]
    var distance: Float = 0.0
    var transform = Transform()
    var aspect: Float = 1
    var viewSize: CGFloat = 10
    var near: Float = 0.1
    var fov: Float = 0.0
    var far: Float = 100
    mutating func hideCursor() {}
    mutating func showCursor() {}
    
    var viewMatrix: float4x4 {
        (float4x4(translation: position) *
         float4x4(rotation: rotation)).inverse
    }
    
    var projectionMatrix: float4x4 {
        let rect = CGRect(
            x: -viewSize * CGFloat(aspect) * 0.5,
            y: viewSize * 0.5,
            width: viewSize * CGFloat(aspect),
            height: viewSize)
        return float4x4(orthographic: rect, near: near, far: far)
    }
    
    mutating func update(size: CGSize) {
        aspect = Float(size.width / size.height)
    }
    
    mutating func update(deltaTime: Float) {
        let transform = updateInput(deltaTime: deltaTime)
        position += transform.position
        let input = InputController.shared
        let zoom = input.mouseScroll.x + input.mouseScroll.y
        viewSize -= CGFloat(zoom)
        input.mouseScroll = .zero
    }
}

