import MetalKit

class DefaultModel: GameObject {
    var vertices: [Float]
    var indices: [UInt16]
    var colors: [simd_float3]
    
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    let colorBuffer: MTLBuffer
    
    init(name: String,
         renderPipeline: MTLRenderPipelineState,
         vertices: [Float],
         indices: [UInt16],
         colors: [simd_float3],
         device: MTLDevice,
         scale: Float = 1) {
        self.vertices = vertices.map { $0 * scale }
        self.indices = indices
        self.colors = colors
        
        guard let vertexBuffer = device.makeBuffer(
            bytes: &self.vertices,
            length: MemoryLayout<Float>.stride * self.vertices.count,
            options: []) else {
            fatalError("Unable to create vertex buffer")
        }
        self.vertexBuffer = vertexBuffer
        
        guard let indexBuffer = device.makeBuffer(
            bytes: &self.indices,
            length: MemoryLayout<UInt16>.stride * self.indices.count,
            options: []) else {
            fatalError("Unable to create index buffer")
        }
        self.indexBuffer = indexBuffer
        
        guard let colorBuffer = device.makeBuffer(
            bytes: &self.colors,
            length: MemoryLayout<simd_float3>.stride * self.indices.count,
            options: []) else {
            fatalError("Unable to create color buffer")
        }
        self.colorBuffer = colorBuffer
        super.init(name: name, renderPipeline: renderPipeline)
    }
    
    override func render(encoder: MTLRenderCommandEncoder, uniforms vertex: Uniforms, params fragment: Params) {
        var uniforms = vertex
        var params = fragment
        
        uniforms.modelMatrix = transform.modelMatrix
        
        encoder.setFragmentBytes(
            &params,
            length: MemoryLayout<Params>.stride,
            index: ParamsBuffer.index)
        encoder.setVertexBytes(
            &uniforms,
            length: MemoryLayout<Uniforms>.stride,
            index: UniformsBuffer.index)
    }
}

