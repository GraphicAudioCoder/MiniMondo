#include <metal_stdlib>
#include "Common.h"
using namespace metal;


struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

vertex VertexOut vertex_main_default_model(VertexIn in [[stage_in]],
                                     constant Uniforms &uniforms [[buffer(11)]])
{
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
    VertexOut out {
        .position = position,
        .color = in.color,
    };
    return out;
}

fragment float4 fragment_main_default_model(VertexOut in [[stage_in]]) {
    return in.color;
}


