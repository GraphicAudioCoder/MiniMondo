import MetalKit

class CartoonCottageLighting: SceneLighting {
    
    
    override init() {
        super.init()
        let sun = sunlight
        var fillLight = SceneLighting.buildDefaultLight()
        fillLight.position = [-5, 1, 3]
        fillLight.color = float3(repeating: 0.4)
        lights.append(sun)
        lights.append(fillLight)
    }
}
