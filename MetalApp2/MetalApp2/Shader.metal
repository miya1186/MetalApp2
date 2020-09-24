//
//  Shader.metal
//  MetalApp2
//
//  Created by miyazawaryohei on 2020/09/23.
//

#include <metal_stdlib>
using namespace metal;

struct ColorInOut
{
    float4 position[[position]];
};

//冒頭のvertex 頂点シェーダの関数であることを宣言
vertex ColorInOut vertexShader(constant float4 *positions [[ buffer(0) ]],
                                        uint    vid       [[ vertex_id ]])
{
    ColorInOut out;
    out.position = positions[vid];
    return out;
}
//冒頭のfragment フラグメントシェーダ関数であることを宣言
fragment float4 fragmentShader(ColorInOut in [[ stage_in ]])
{
    return float4(1,0,0,1);
}
