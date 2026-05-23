//===================================================================================================================
//===================================================================================================================
#include "GSFX_Shaders_Tonemapping.fxh"
//===================================================================================================================
//===================================================================================================================
uniform float TONEMAPPING_LIGHTING <
ui_label = "TONEMAPPING_LIGHTING";
ui_type = "drag";
> = 3.0;
uniform float TONEMAPPING_SATURATION <
ui_label = "TONEMAPPING_SATURATION";
ui_type = "drag";
> = 3.0;
//===================================================================================================================
//===================================================================================================================
texture GSFX_Texture_A { Width = BUFFER_WIDTH * 0.25; Height = BUFFER_HEIGHT * 0.25; Format = RGBA16; };
texture GSFX_Texture_B { Width = BUFFER_WIDTH * 0.25; Height = BUFFER_HEIGHT * 0.25; Format = RGBA16; };
sampler2D GSFX_Sampler_A { Texture = GSFX_Texture_A; MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR; AddressU = Clamp; AddressV = Clamp; };
sampler2D GSFX_Sampler_B { Texture = GSFX_Texture_B; MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR; AddressU = Clamp; AddressV = Clamp; };
//===================================================================================================================
float4 GaussBlurF ( float2 coords : TEXCOORD ) : COLOR { float4 ret = max ( tex2D ( SamplerColor, coords ) - 0.0, 0.0 );
for ( int i=1.0; i < 12.0; i++ ) { ret += max ( tex2D ( SamplerColor, coords + float2 ( i * PixelSize.x * 10.0, 0.0 ) ) - 0.0, 0.0 );
ret += max ( tex2D ( SamplerColor, coords - float2 ( i * PixelSize.x * 10.0, 0.0 ) ) - 0.0, 0.0 ); } return ret / ( 1.0 - 0.0 ) / 23.0; }
float4 GaussBlurH ( float2 coords : TEXCOORD ) : COLOR { float4 ret = tex2D ( GSFX_Sampler_B, coords );
for ( int i=1.0; i < 12.0; i++ ) { ret += tex2D ( GSFX_Sampler_B, coords + float2 ( i * PixelSize.x * 10.0, 0.0 ) );
ret += tex2D ( GSFX_Sampler_B, coords - float2 ( i * PixelSize.x * 10.0, 0.0 ) ); } return ret / 23.0; }
float4 GaussBlurV ( float2 coords : TEXCOORD ) : COLOR { float4 ret = tex2D ( GSFX_Sampler_A, coords );
for ( int i=1.0; i < 12.0; i++ ) { ret += tex2D ( GSFX_Sampler_A, coords + float2 ( 0.0, i * PixelSize.y * 10.0 ) ); 
ret += tex2D ( GSFX_Sampler_A, coords - float2 ( 0.0, i * PixelSize.y * 10.0 ) ); } return ret / 23.0; }
float4 GSFX_Shaders_Bloom_A ( float4 vpos : SV_Position, float2 texcoord : TEXCOORD ) : COLOR { return GaussBlurF ( texcoord ); }
float4 GSFX_Shaders_Bloom_C ( float4 vpos : SV_Position, float2 texcoord : TEXCOORD ) : COLOR { return GaussBlurH ( texcoord ); }
float4 GSFX_Shaders_Bloom_B ( float4 vpos : SV_Position, float2 texcoord : TEXCOORD ) : COLOR { return GaussBlurV ( texcoord ); }
float4 GSFX_Shaders_Bloom_D ( float4 vpos : SV_Position, float2 texcoord : TEXCOORD ) : COLOR
{ float4 ret = tex2D ( SamplerColor, texcoord ); float4 bloom = tex2D ( GSFX_Sampler_B, texcoord );
bloom.rgb = lerp ( dot ( bloom.rgb, float3 ( 0.3, 0.3, 0.3 ) ), bloom.rgb, TONEMAPPING_SATURATION ) * TONEMAPPING_LIGHTING * 0.1;
ret.rgb += bloom.rgb * saturate ( 1.0 - ret.rgb ); return ret; }
//===================================================================================================================
float4 GSFX_Shaders_Bloom_E ( float4 vpos : SV_Position, float2 texcoord : TexCoord ) : SV_Target
{ float4 colorInput = tex2D ( SamplerColor, texcoord );
float3 lumCoeff = float3 ( 0.3, 0.3, 0.3 ); float Contrast_blend = TONEMAPPING_LIGHTING * 0.2;
float luma = dot ( lumCoeff, colorInput.rgb ); float3 chroma = colorInput.rgb - luma;
float3 x; x = luma; x = x * x * ( 3.0 - 2.0 * x ); x = lerp ( luma, x, Contrast_blend );
colorInput.rgb = x + chroma; return colorInput; }
//===================================================================================================================
float3 GSFX_Shaders_Bloom_F ( float4 position : SV_Position, float2 texcoord : TexCoord ) : SV_Target
{ const float4 x = tex2D ( SamplerColor, texcoord );
const float3 A = 0.5f; const float3 B = 0.17f; const float3 C = 1.83f;
const float3 D = 1.1f; const float3 E = 0.05f; const float3 F = 0.57f; const float3 W = 1.0f;
const float3 F_linearWhite = ( ( W * ( A * W + C * B ) + D * E ) / ( W * ( A * W + B ) + D * F ) ) - ( E / F );
const float3 F_linearColor = ( ( x .xyz * ( A * x.xyz + C * B ) + D * E ) / ( x.xyz * ( A * x.xyz + B ) + D * F ) ) - ( E / F );
return pow ( saturate ( F_linearColor / F_linearWhite ), 1.0 ); }
//===================================================================================================================
float4 GSFX_Shaders_Bloom_G ( float4 vpos : SV_Position, float2 texcoord : TEXCOORD ) : SV_Target
{ float4 colorInput = tex2D ( SamplerColor, texcoord ); float2 pixel = PixelSize;
float3 pixel1 = tex2D ( SamplerColor, texcoord + float2 ( ( pixel.x ), 0.0 ) ).rgb;
float3 pixel2 = tex2D ( SamplerColor, texcoord + float2 ( -pixel.x, 0.0 ) ).rgb;
float3 pixelblend; { float3 pixeldiff; float3 pixelmake; float3 pixeldiffleft;
pixelmake.rgb = 0.0; pixeldiff.rgb = pixel2.rgb - colorInput.rgb;
pixeldiffleft.rgb = pixel1.rgb - colorInput.rgb;
pixelmake.rgb = ( pixeldiff.rgb / 4.0 ) + ( pixeldiffleft.rgb / 16.0 );
colorInput.rgb = ( colorInput.rgb + pixelmake.rgb ); } return colorInput; }
//===================================================================================================================
//===================================================================================================================
technique GSFX_Shaders_Tonemapping
{
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Bloom_A; RenderTarget = GSFX_Texture_A; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Bloom_B; RenderTarget = GSFX_Texture_B; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Bloom_C; RenderTarget = GSFX_Texture_A; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Bloom_B; RenderTarget = GSFX_Texture_B; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Bloom_D; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Bloom_E; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Bloom_F; }
pass { VertexShader = PostProcessVS; PixelShader = GSFX_Shaders_Bloom_G; }
}
//===================================================================================================================
//===================================================================================================================