#include <metal_stdlib>
#import "Lighting.h"
using namespace metal;


struct VertexIn {
    float4 position [[attribute(0)]];
    float3 normal [[attribute(1)]];
    float2 uv [[attribute(UV)]];
    float3 color [[attribute(Color)]];
    float3 tangent [[attribute(Tangent)]];
    float3 bitangent [[attribute(Bitangent)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 normal;
    float2 uv;
    float3 color;
    float3 worldPosition;
    float3 worldNormal;
    float3 worldTangent;
    float3 worldBitangent;
};

vertex VertexOut vertex_main_model(VertexIn in [[stage_in]],
                                   constant Uniforms &uniforms [[buffer(UniformsBuffer)]])
{
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
    float3 normal = in.normal;
    VertexOut out {
        .position = position,
        .normal = normal,
        .uv = in.uv,
        .color = in.color,
        .worldPosition = (uniforms.modelMatrix * in.position).xyz,
        .worldNormal = uniforms.normalMatrix * in.normal,
        .worldTangent = uniforms.normalMatrix * in.tangent,
        .worldBitangent = uniforms.normalMatrix * in.bitangent
    };
    
    return out;
}

fragment float4 fragment_main_model(VertexOut in [[stage_in]],
                                    texture2d<float> baseColorTexture [[texture(BaseColor)]],
                                    texture2d<float> normalTexture [[texture(NormalTexture)]],
                                    constant Light *lights [[buffer(LightBuffer)]],
                                    constant Params &params [[buffer(ParamsBuffer)]],
                                    constant Material &_material [[buffer(MaterialBuffer)]])
{
    Material material = _material;
    
    constexpr sampler textureSampler(filter::linear,
                                     address::repeat,
                                     mip_filter::linear,
                                     max_anisotropy(8));
    if (!is_null_texture(baseColorTexture)) {
      material.baseColor = baseColorTexture.sample(
      textureSampler,
      in.uv * params.tiling).rgb;
    }
//    float3 normalDirection = normalize(in.worldNormal);
    float3 normal;
    if (is_null_texture(normalTexture)) {
        normal = in.worldNormal;
    } else {
        normal = normalTexture.sample(textureSampler,
                                      in.uv * params.tiling).rgb;
        normal = normal * 2 - 1;
        normal = float3x3(in.worldTangent,
                          in.worldBitangent,
                          in.worldNormal) * normal;
    }
    normal = normalize(normal);
    float3 color = phongLighting(normal,
                                 in.worldPosition,
                                 params,
                                 lights,
                                 material);
    return float4(color, 1);
}
