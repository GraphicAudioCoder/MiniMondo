import MetalKit

class MiniMondoController: MTKView {
    var renderer: GameController!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        renderer = GameController(metalView: self)
    }
}
