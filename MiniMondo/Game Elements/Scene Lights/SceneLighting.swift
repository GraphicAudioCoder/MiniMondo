import MetalKit

class SceneLighting {
    
    var lights: [Light] = []
    
    init() { }
    
    var redLight: Light = {
        var light = SceneLighting.buildDefaultLight()
        light.type = Point
        light.position = [-0.8, 0.76, -0.18]
        light.color = [1, 0, 0]
        light.attenuation = [0.5, 2, 1]
        return light
    }()
    
    var spotlight: Light = {
        var light = SceneLighting.buildDefaultLight()
        light.type = Spot
        light.position = [-0.64, 0.64, -1.07]
        light.color = [1, 0, 1]
        light.attenuation = [1, 0.5, 0]
        light.coneAngle = Float(40).degreesToRadians
        light.coneDirection = [0.5, -0.7, 1]
        light.coneAttenuation = 8
        return light
    }()
    
    var sunlight: Light = {
        var light = SceneLighting.buildDefaultLight()
        light.position = [1, 2, -2]
        return light
    }()
    
    var ambientLight: Light = {
        var light = SceneLighting.buildDefaultLight()
        light.color = [0.05, 0.1, 0]
        light.type = Ambient
        return light
    }()
    
    static func buildDefaultLight() -> Light {
        var light = Light()
        light.position = [0, 0, 0]
        light.color = [1, 1, 1]
        light.specularColor = [0.6, 0.6, 0.6]
        light.attenuation = [1, 0, 0]
        light.type = Sun
        return light
    }
    
}
