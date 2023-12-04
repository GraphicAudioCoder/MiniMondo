import CoreGraphics
import Cocoa

struct PlayerCamera: Camera {
    var transform = Transform()
    
    var aspect: Float = 1.0
    var fov = Float(70).degreesToRadians
    var near: Float = 0.1
    var far: Float = 100
    var projectionMatrix: float4x4 {
        float4x4(
            projectionFov: fov,
            near: near,
            far: far,
            aspect: aspect)
    }
    
    private var isCursorHidden = false {
        didSet {
            updateCursorVisibility()
        }
    }
    
    mutating func update(size: CGSize) {
        aspect = Float(size.width / size.height)
    }
    
    var viewMatrix: float4x4 {
        let rotateMatrix = float4x4(
            rotationYXZ: [-rotation.x, rotation.y, 0])
        return (float4x4(translation: position) * rotateMatrix).inverse
    }
    
    private func updateCursorVisibility() {
        if isCursorHidden {
            NSCursor.hide()
        } else {
            NSCursor.unhide()
        }
    }
    
    mutating func hideCursor() {
        isCursorHidden = true
    }
    
    mutating func showCursor() {
        isCursorHidden = false
    }
    
    mutating func update(deltaTime: Float) {
        let transform = updateInput(deltaTime: deltaTime)
        rotation += transform.rotation
        position += transform.position
        
        let input = InputController.shared
        let sensitivity = Settings.mousePanSensitivity
        
        // Aggiorna la rotazione anche se il pulsante del mouse non è premuto
        rotation.x += input.mouseDelta.y * sensitivity
        rotation.y += input.mouseDelta.x * sensitivity
        rotation.x = max(-.pi / 2, min(rotation.x, .pi / 2))
        input.mouseDelta = .zero
    }
    
}

extension PlayerCamera: Movement { }
