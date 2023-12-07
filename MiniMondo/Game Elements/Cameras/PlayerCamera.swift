import CoreGraphics
import AVFoundation
import Cocoa

struct PlayerCamera: Camera {
    var models: [GameObject] = []
    
    var target: float3 = [0.0, 0.0, 0.0]
    var distance: Float = 0.0
    var transform = Transform()
    var aspect: Float = 1.0
    var fov = Float(70).degreesToRadians
    var near: Float = 0.1
    var far: Float = 100
    
    private var wasSpacebarPressed = false
    private var jumpVelocity: Float = 0.7
    private var jumpHeight: Float = 2.0
    private var currentJumpTime: Float = 0.0
    private var isJumping = false
    private var cameraY: Float = 1.5
    private var mouseClickTime: Float = 0.0
    
    private var gunshotSound: AVAudioPlayer?
    private var walkSound: AVAudioPlayer?
    private var jumpSound: AVAudioPlayer?
    private var timeSinceLastGunshot: Float = 0.0
    private var timeSinceLastWalk: Float = 0.0
    
    init() {
        playWalkSound()
    }
    
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
            if isCursorHidden {
                dissociateMouse()
            } else {
                associateMouse()
            }
        }
    }
    
    mutating func update(size: CGSize) {
        aspect = Float(size.width / size.height)
    }
    
    private func associateMouse() {
        CGAssociateMouseAndMouseCursorPosition(1)
    }
    
    private func dissociateMouse() {
        CGAssociateMouseAndMouseCursorPosition(0)
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
        
        if input.keysPressed.contains(.spacebar) && !isJumping {
            cameraY = position.y
            isJumping = true
            currentJumpTime = 0.0
            playJumpSound()
        }
        
        if isJumping {
            let jumpProgress = currentJumpTime / jumpVelocity
            
            // Calcolo dell'altezza del salto con un effetto di ammortizzazione più sottile
            let jumpOffset = jumpHeight * sin(jumpProgress * .pi) * (1.0 - jumpProgress * 0.2)
            
            position.y = cameraY + jumpOffset
            
            currentJumpTime += deltaTime
            
            if currentJumpTime >= jumpVelocity {
                isJumping = false
                position.y = cameraY
            }
        }
        
        timeSinceLastGunshot += deltaTime
        timeSinceLastWalk += deltaTime
        
        if input.leftMouseDown {
            mouseClickTime += deltaTime
            let verticalOffset = 0.1 * sin(mouseClickTime * 50 * .pi)
            position.y += verticalOffset
            //play audio
            if timeSinceLastGunshot >= 0.1 {
                playGunshotSound()
                timeSinceLastGunshot = 0.0
            }
        } else {
            mouseClickTime = 0.0
            if(!isJumping) {
                position.y = cameraY
            }
        }
        
        if (input.keysPressed.contains(.keyA) ||
            input.keysPressed.contains(.keyW) ||
            input.keysPressed.contains(.keyS) ||
            input.keysPressed.contains(.keyD) ) {
            
            var walkOffset: Float = 0.7
            
            if input.keysPressed.contains(.leftShift) {
                walkOffset /= 2
            }
            if !isJumping {
                if timeSinceLastWalk >= walkOffset {
                    playWalkSound()
                    timeSinceLastWalk = 0.0
                }
            }
        }
    }
    
    private mutating func playGunshotSound() {
        guard let soundURL = Bundle.main.url(forResource: "gunshot", withExtension: "wav") else {
            print("Errore nel trovare il file audio gunshot.wav")
            return
        }
        
        do {
            gunshotSound = try AVAudioPlayer(contentsOf: soundURL)
            gunshotSound?.prepareToPlay()
            gunshotSound?.play()
        } catch let error as NSError {
            print("Errore durante la riproduzione del suono: \(error.localizedDescription)")
        }
    }
    
    private mutating func playWalkSound() {
        guard let soundURL = Bundle.main.url(forResource: "walk", withExtension: "wav") else {
            print("Errore nel trovare il file audio walk.wav")
            return
        }
        
        do {
            walkSound = try AVAudioPlayer(contentsOf: soundURL)
            walkSound?.prepareToPlay()
            walkSound?.play()
        } catch let error as NSError {
            print("Errore durante la riproduzione del suono: \(error.localizedDescription)")
        }
    }
    
    private mutating func playJumpSound() {
        guard let soundURL = Bundle.main.url(forResource: "jump", withExtension: "wav") else {
            print("Errore nel trovare il file audio walk.wav")
            return
        }
        
        do {
            jumpSound = try AVAudioPlayer(contentsOf: soundURL)
            jumpSound?.volume = 0.5
            jumpSound?.prepareToPlay()
            jumpSound?.play()
        } catch let error as NSError {
            print("Errore durante la riproduzione del suono: \(error.localizedDescription)")
        }
    }
    
}

extension PlayerCamera: Movement { }
