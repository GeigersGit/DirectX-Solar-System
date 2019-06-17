//--------------------------------------------------------------------------------------
// File: lecture 8.fx
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
Texture2D txDiffuse : register( t0 );
Texture2D txDepth : register(t1);
SamplerState samLinear : register( s0 );

cbuffer ConstantBuffer : register( b0 )
{
matrix World;
matrix View;
matrix Projection;
float4 info;
};



//--------------------------------------------------------------------------------------
struct VS_INPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
	float3 Norm : NORMAL0;
};

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float2 Tex : TEXCOORD0;
	float4 Col : COLOR0;
};


//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------

PS_INPUT VS(VS_INPUT input)
	{
	PS_INPUT output = (PS_INPUT)0;
	float4 pos = input.Pos;
	pos = mul(pos, World);
	output.Pos = mul(pos, View);
	output.Pos = mul(output.Pos, Projection);
	output.Tex = input.Tex;
	//lighing:
	//also turn the light normals in case of a rotation:
	float3 norm = mul(input.Norm, World);
	//lets assume a light at pos 1000,1000,1000
	float3 lightpos = float3(0, 0, 60);
	//vector from lightcource to vertex:
	float3 lightdirection = normalize(lightpos - pos.xyz);
	float3 light = dot(lightdirection, normalize(norm));
	output.Col.rgba = light.r;

	//output.Col.rgb = input.Norm;



	return output;
	}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( PS_INPUT input) : SV_Target
{
    float4 color = txDiffuse.Sample( samLinear, input.Tex );
	color *= input.Col.r;
	color.a = 1;
	//color.rgb = input.Col;
	return color;
}
