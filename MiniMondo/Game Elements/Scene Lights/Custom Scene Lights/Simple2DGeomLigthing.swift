import MetalKit

class Simple2DGeomLigthing: SceneLighting {
    override init() {
        super.init()
        var light = ambientLight
        light.color = [1, 1, 1]
        lights.append(light)
    }
}
