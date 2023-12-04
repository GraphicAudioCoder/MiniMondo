#include <metal_stdlib>
#import "Common.h"
using namespace metal;


struct VertexIn {
    float4 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
};

vertex VertexOut vertex_main_model(VertexIn in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(11)]])
{
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
    
    VertexOut out {
        .position = position
    };
    
    return out;
}

fragment float4 fragment_main_model(VertexOut in [[stage_in]],
                              constant Params &params [[buffer(12)]])
{
    float3 color = normalize(in.position.xyz);
    return float4(color, 1);
}
