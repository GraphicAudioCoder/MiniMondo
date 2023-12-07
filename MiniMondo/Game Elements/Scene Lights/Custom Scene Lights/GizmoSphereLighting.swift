import MetalKit

class GizmoSphereLighting: SceneLighting {
    override init() {
        super.init()
        lights.append(sunlight)
        lights.append(ambientLight)
        lights.append(redLight)
        lights.append(spotlight)
    }
}
