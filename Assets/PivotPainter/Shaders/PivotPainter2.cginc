
sampler2D _posAndIndexTex;
sampler2D _xVectorAndExtentTex;


float4 _posAndIndexTex_TexelSize;		
float4 _xVectorAndExtentTex_TexelSize;
float4 SampleXVectorAndExtent( float2 uv)
{						
    uv.y = 1- uv.y;
    return tex2Dlod(_xVectorAndExtentTex, float4(uv,0, 0));
}


float4 SamplePivotAndIndex(  float2 uv)
{						
    uv.y = 1- uv.y;
    return tex2Dlod(_posAndIndexTex,float4(uv,0, 0));
}

float3 ConvertCoord(float3 pos)
{
    return float3( pos.xzy)*float3(-1,1,1)*_MetricScale;
}

float3 DecodeAxisVector(float3 rgb)
{
    rgb = (rgb-0.5)*2;
    rgb = rgb.xzy*float3(-1,1,1);
    float3 r =  normalize(mul(unity_ObjectToWorld,float4(rgb,0))).xyz;
    return r.xyz;
}

float3 DecodeAxisVectorLocal(float3 rgb)
{
    rgb = (rgb-0.5)*2;
    rgb = rgb.xzy*float3(-1,1,1);
    return rgb.xyz;
    
}

float Decode8BitAlphaAxisExtent(float a)
{
    return max(8, a*2048)*_MetricScale;
}

struct Hierachy
{
    int level;
    float2 pivotUVs[4];
    float2 extentUVs[4];
    
};

float UnpackIntegerAsFloat(float integerAsFloat)
{
    uint uRes32 = asuint(integerAsFloat);

    const uint sign2 = ((uRes32>>16)&0x8000);
    const uint _exp2  = (((( int) ((uRes32>>23)&0xff))-127+15) << 10);
    const uint mant2 = ((uRes32>>13)&0x3ff);
    const uint bits = (sign2 | _exp2 | mant2);
    const uint result = bits - 1024;
    return float(result);
}

float3 GetParentTextureInfo(float2 textureSize, float parentIndexAsFloat, float currentIndex)
{
    float2 uv = float2( fmod(parentIndexAsFloat,textureSize.x), floor(parentIndexAsFloat/textureSize.x))+0.5;
    float3 ret;
    ret.xy = uv/textureSize;
    if ( currentIndex != parentIndexAsFloat )
    ret.z = 1;
    else
    ret.z = 0;
    return ret;
}

float CalcMeshElementIndex( float2 uv, float2 textureSize)
{
    float2 p = floor(uv*textureSize);
    return dot(p, float2(1,textureSize.x));
}

float4 RebuildHierachy( float2 uv, float2 textureSize, out  Hierachy hierachy)
{
    
    // hierachy = (Hierachy)0;
    int level = 0;
    uv.y = 1-uv.y;//unity flipped the uv.y
    float currentIndex = CalcMeshElementIndex(uv,textureSize);
    
    float4 Pixel0 = SamplePivotAndIndex(uv);
    hierachy.pivotUVs[0] = uv;
    hierachy.extentUVs[0] = uv;
    

    float parentIndex0 = UnpackIntegerAsFloat(Pixel0.a);
    float3 parentInfo0 = GetParentTextureInfo( textureSize, parentIndex0, currentIndex);
    level += parentInfo0.z;
    

    float4 Pixel1 = SamplePivotAndIndex(parentInfo0.xy);
    hierachy.pivotUVs[1] = parentInfo0.xy;
    hierachy.extentUVs[1] = parentInfo0.xy;
    //  hierachy.extentUVs[1].y = 1- hierachy.extentUVs[1].y;

    float parentIndex1 = UnpackIntegerAsFloat(Pixel1.a);
    float3 parentInfo1 = GetParentTextureInfo( textureSize, parentIndex1, parentIndex0);
    level += parentInfo1.z;

    
    float4 Pixel2 = SamplePivotAndIndex(parentInfo1.xy);
    hierachy.pivotUVs[2] = parentInfo1.xy;
    hierachy.extentUVs[2] = parentInfo1.xy;


    float parentIndex2 = UnpackIntegerAsFloat(Pixel2.a);
    float3 parentInfo2 = GetParentTextureInfo( textureSize, parentIndex2, parentIndex1);
    level += parentInfo2.z;			

    float4 Pixel3 = SamplePivotAndIndex(parentInfo2.xy);
    hierachy.pivotUVs[3] = parentInfo2.xy;
    hierachy.extentUVs[3] = parentInfo2.xy;
    // hierachy.extentUVs[3].y = 1- hierachy.extentUVs[1].y;

    hierachy.level = level;
    
    return float4(level,level,level,level);

    // float4 p2 = tex2D(texPivotPosAndIndex,pivot1);
    // float4 p3 = tex2D(texPivotPosAndIndex,pivot2);
}