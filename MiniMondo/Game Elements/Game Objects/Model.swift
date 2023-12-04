import MetalKit

class Model: GameObject {
    let meshes: [Mesh]
    
    init(name: String) {
        
        let defaultPipeline: BasicRenderPipeline =
        BasicRenderPipeline(device: Renderer.device,
                            vertexFunction: "vertex_main_model",
                            fragmentFunction: "fragment_main_model",
                            colorPixelFormat: Preferences.colorPixelFormat,
                            vertexDescriptor: MTLVertexDescriptor.externalLayout!)
        
        guard let assetURL = Bundle.main.url(
            forResource: name,
            withExtension: nil) else {
            fatalError("Model: \(name) not found")
        }
        let allocator = MTKMeshBufferAllocator(device: Renderer.device)
        let asset = MDLAsset(url: assetURL, vertexDescriptor: .externalLayout, bufferAllocator: allocator)
        let (mdlMeshes, mtkMeshes) = try! MTKMesh.newMeshes(asset: asset, device: Renderer.device)
        meshes = zip(mdlMeshes, mtkMeshes).map {
            Mesh(mdlMesh: $0.0, mtkMesh: $0.1)
        }
        super.init(name: name, renderPipeline: defaultPipeline.pipelineState)
    }
    
    // Rendering
    override func render(encoder: MTLRenderCommandEncoder, uniforms vertex: Uniforms, params fragment: Params) {
        var uniforms = vertex
        var params = fragment
        params.tiling = tiling
        encoder.setRenderPipelineState(renderPipeline)
        uniforms.modelMatrix = transform.modelMatrix
        
        encoder.setVertexBytes(
            &uniforms,
            length: MemoryLayout<Uniforms>.stride,
            index: UniformsBuffer.index)
        
        encoder.setFragmentBytes(
            &params,
            length: MemoryLayout<Uniforms>.stride,
            index: ParamsBuffer.index)
        
        for mesh in meshes {
            for (index, vertexBuffer) in mesh.vertexBuffers.enumerated() {
                encoder.setVertexBuffer(
                    vertexBuffer,
                    offset: 0,
                    index: index)
            }
            
            for submesh in mesh.submeshes {
                
                encoder.setFragmentTexture(
                  submesh.textures.baseColor,
                  index: BaseColor.index)
                
                encoder.drawIndexedPrimitives(
                    type: .triangle,
                    indexCount: submesh.indexCount,
                    indexType: submesh.indexType,
                    indexBuffer: submesh.indexBuffer,
                    indexBufferOffset: submesh.indexBufferOffset
                )
            }
        }
    }
}
