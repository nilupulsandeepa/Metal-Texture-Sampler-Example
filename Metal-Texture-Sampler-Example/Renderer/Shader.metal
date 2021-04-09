//
//  Shader.metal
//  Metal-Texture-Sampler-Example
//
//  Created by Nilupul Sandeepa on 2021-04-09.
//

#include <metal_stdlib>
using namespace metal;


struct VertexOut {
    float4 pos [[position]];
    float2 texCoords;
};

vertex VertexOut vertexFunction (constant float2 *vertices [[buffer(0)]],
                                 constant float2 *textureCoords [[buffer(1)]],
                                 uint vertexId [[vertex_id]]) {
    VertexOut vOut;
    vOut.pos = float4(vertices[vertexId].x, vertices[vertexId].y, 0.0, 1.0);
    vOut.texCoords = textureCoords[vertexId];
    return vOut;
}

fragment float4 fragmentFunction (VertexOut vIn [[stage_in]],
                                  texture2d<float> texture [[texture(0)]],
                                  sampler samplr [[sampler(0)]]
                                  ) {
    //You can use samplers in shader also by changing -> address mode
    //constexpr sampler colorSampler(mip_filter::none, mag_filter::linear, min_filter::linear, address::clamp_to_edge);
    float4 color = texture.sample(samplr, vIn.texCoords);
    return color;
}
