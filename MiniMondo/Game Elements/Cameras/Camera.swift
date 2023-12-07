import CoreGraphics

protocol Camera: Transformable {
    var projectionMatrix: float4x4 { get }
    var viewMatrix: float4x4 { get }
    mutating func update(size: CGSize)
    mutating func update(deltaTime: Float)
    var fov: Float { get }
    var near: Float { get }
    var aspect: Float { get }
    var target: float3 { set get }
    var distance: Float { set get }
    var models: [GameObject] { set get }
    mutating func hideCursor()
    mutating func showCursor()
}
