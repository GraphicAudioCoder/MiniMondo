#include <metal_stdlib>
#import "Lighting.h"
using namespace metal;

float3 phongLighting(float3 normal,
                     float3 position,
                     constant Params &params,
                     constant Light *lights,
                     Material material) {
    float3 baseColor = material.baseColor;
    float3 diffuseColor = 0;
    float3 ambientColor = 0;
    float3 specularColor = 0;
    float materialShininess = material.shininess;
    float3 materialSpecularColor = material.specularColor;
    
    for (uint i = 0; i < params.lightCount; i++) {
        Light light = lights[i];
        switch (light.type) {
            case Sun: {
                float3 lightDirection = normalize(-light.position);
                float diffuseIntensity = saturate(-dot(lightDirection, normal));
                diffuseColor += light.color * baseColor * diffuseIntensity;
                if (diffuseIntensity > 0) {
                  float3 reflection = reflect(lightDirection, normal);
                  float3 viewDirection = normalize(params.cameraPosition);
                  float specularIntensity = pow(saturate(dot(reflection, viewDirection)), materialShininess);
                  specularColor += light.specularColor * materialSpecularColor * specularIntensity;
                }
                break; }
            case Point: {
                float d = distance(light.position, position);
                float3 lightDirection = normalize(light.position - position);
                float attenuation = 1.0 / (light.attenuation.x +
                    light.attenuation.y * d + light.attenuation.z * d * d);
                float diffuseIntensity = saturate(dot(lightDirection, normal));
                float3 color = light.color * baseColor * diffuseIntensity;
                color *= attenuation;
                diffuseColor += color;
                break; }
            case Spot: {
                float d = distance(light.position, position);
                float3 lightDirection = normalize(light.position - position);
                float3 coneDirection = normalize(light.coneDirection);
                float spotResult = dot(lightDirection, -coneDirection);
                if (spotResult > cos(light.coneAngle)) {
                  float attenuation = 1.0 / (light.attenuation.x +
                      light.attenuation.y * d + light.attenuation.z * d * d);
                  attenuation *= pow(spotResult, light.coneAttenuation);
                  float diffuseIntensity = saturate(dot(lightDirection, normal));
                  float3 color = light.color * baseColor * diffuseIntensity;
                  color *= attenuation;
                  diffuseColor += color;
                }
                break; }
            case Ambient: {
                ambientColor += light.color * baseColor;
                break; }
            case Unused: {
                break; }
        }
    }
    return diffuseColor + specularColor + ambientColor;
}




