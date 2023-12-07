import MetalKit

extension MTLVertexDescriptor {
    static var defaultLayout: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        let stride = MemoryLayout<Float>.stride * 3
        vertexDescriptor.layouts[0].stride = stride
        
        vertexDescriptor.attributes[1].format = .float3
        vertexDescriptor.attributes[1].offset = 0
        vertexDescriptor.attributes[1].bufferIndex = 1
        vertexDescriptor.layouts[1].stride =
        MemoryLayout<simd_float3>.stride
        
        return vertexDescriptor
    }
    static var externalLayout: MTLVertexDescriptor? {
        MTKMetalVertexDescriptorFromModelIO(.externalLayout)
    }
}

extension MDLVertexDescriptor {
    static var externalLayout: MDLVertexDescriptor {
        let vertexDescriptor = MDLVertexDescriptor()
        var offset = 0
        vertexDescriptor.attributes[Position.index] = MDLVertexAttribute(
            name: MDLVertexAttributePosition,
            format: .float3,
            offset: 0,
            bufferIndex: VertexBuffer.index)
        offset += MemoryLayout<float3>.stride
        
        vertexDescriptor.attributes[Normal.index] = MDLVertexAttribute(
            name: MDLVertexAttributeNormal,
            format: .float3,
            offset: offset,
            bufferIndex: VertexBuffer.index)
        offset += MemoryLayout<float3>.stride
        vertexDescriptor.layouts[VertexBuffer.index] = MDLVertexBufferLayout(stride: offset)
        
        vertexDescriptor.attributes[UV.index] = MDLVertexAttribute(
            name: MDLVertexAttributeTextureCoordinate,
            format: .float2,
            offset: 0,
            bufferIndex: UVBuffer.index)
        vertexDescriptor.layouts[UVBuffer.index] = MDLVertexBufferLayout(stride: MemoryLayout<float2>.stride)
        
        vertexDescriptor.attributes[Color.index] = MDLVertexAttribute(
            name: MDLVertexAttributeColor,
            format: .float3,
            offset: 0,
            bufferIndex: ColorBuffer.index)
        vertexDescriptor.layouts[ColorBuffer.index] = MDLVertexBufferLayout(stride: MemoryLayout<float3>.stride)
        
        vertexDescriptor.attributes[Tangent.index] =
          MDLVertexAttribute(
            name: MDLVertexAttributeTangent,
            format: .float3,
            offset: 0,
            bufferIndex: TangentBuffer.index)
        vertexDescriptor.layouts[TangentBuffer.index] = MDLVertexBufferLayout(stride: MemoryLayout<float3>.stride)
        
        vertexDescriptor.attributes[Bitangent.index] =
          MDLVertexAttribute(
            name: MDLVertexAttributeBitangent,
            format: .float3,
            offset: 0,
            bufferIndex: BitangentBuffer.index)
        vertexDescriptor.layouts[BitangentBuffer.index] = MDLVertexBufferLayout(stride: MemoryLayout<float3>.stride)
        
        return vertexDescriptor
    }
}

extension Attributes {
    var index: Int {
        return Int(self.rawValue)
    }
}

extension BufferIndices {
    var index: Int {
        return Int(self.rawValue)
    }
}

extension TextureIndices {
    var index: Int {
        return Int(self.rawValue)
    }
}
