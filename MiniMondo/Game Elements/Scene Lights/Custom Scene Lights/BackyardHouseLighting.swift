import MetalKit

class BackyardHouseLighting: SceneLighting {
    override init() {
        super.init()
        var light = ambientLight
        light.color = [1, 1, 1]
        lights.append(light)
    }
}
