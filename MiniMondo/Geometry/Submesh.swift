import MetalKit

struct Submesh {
    let indexCount: Int
    let indexType: MTLIndexType
    let indexBuffer: MTLBuffer
    let indexBufferOffset: Int
    
    struct Textures {
        let baseColor: MTLTexture?
        let normal: MTLTexture?
        let roughness: MTLTexture?
    }
    
    let textures: Textures
    let material: Material
}

extension Submesh {
    init(mdlSubmesh: MDLSubmesh, mtkSubmesh: MTKSubmesh) {
        indexCount = mtkSubmesh.indexCount
        indexType = mtkSubmesh.indexType
        indexBuffer = mtkSubmesh.indexBuffer.buffer
        indexBufferOffset = mtkSubmesh.indexBuffer.offset
        textures = Textures(material: mdlSubmesh.material)
        material = Material(material: mdlSubmesh.material)
    }
}

private extension Submesh.Textures {
    init(material: MDLMaterial?) {
        func property(with semantic: MDLMaterialSemantic)
        -> MTLTexture? {
            guard let property = material?.property(with: semantic),
                  property.type == .string,
                  let filename = property.stringValue,
                  let texture =
                    TextureController.texture(filename: filename)
            else { return nil }
            return texture
        }
        baseColor = property(with: MDLMaterialSemantic.baseColor)
        normal = property(with: .tangentSpaceNormal)
        roughness = property(with: .roughness)
    }
}

private extension Material {
    init(material: MDLMaterial?) {
        self.init()
        if let baseColor = material?.property(with: .baseColor),
           baseColor.type == .float3 {
            self.baseColor = baseColor.float3Value
        }
        if let specular = material?.property(with: .specular),
           specular.type == .float3 {
            self.specularColor = specular.float3Value
        }
        if let shininess = material?.property(with: .specularExponent),
           shininess.type == .float {
            self.shininess = shininess.floatValue
        }
        self.ambientOcclusion = 1
        if let roughness = material?.property(with: .roughness),
           roughness.type == .float3 {
            self.roughness = roughness.floatValue
        }
    }
}
