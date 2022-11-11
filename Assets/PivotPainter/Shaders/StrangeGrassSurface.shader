Shader "PivotPainter2/Strange_Grass" {
    Properties {

        _MetricScale("metric scale",float)=0.01
        _LookAt("lookat", Vector)=(0,0,0,0)
        
        _Color ("Color", Color) = (1,1,1,1)
        [HDR]_EmissionColor ("GlowColor", Color) = (1,1,1,1)
        [HDR]_EmissionColorNear ("GlowColor Near", Color) = (1,1,1,1)

        _Color_var ("Color varation", Color) = (1,1,1,1)
        [HDR]_EmissionColor_var ("GlowColor varation", Color) = (1,1,1,1)
        [HDR]_EmissionColorNear_var ("GlowColor Near varation", Color) = (1,1,1,1)

        _MaxSenseDistance("MaxSenseDistance",float) = 30
        _HeatMap("HeatMap", 2D) ="black" {}
        _WorldToHeatMap("World To HeatMap(scale , translate)", vector)=(1,1,0,0)

        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "bump"{}		
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _CutOut ("alpha cutout", Range(0,1)) = 0.0

        _posAndIndexTex("pos and index", 2D) = "white" {}
        _xVectorAndExtentTex("x extent", 2D) = "white" {}
        _UseGravity("UseGravity", range(0,1)) =0.5        
        _WindTex("WindTex (A)", 2D) = "white" {}
        _RotateUV("Wind Direction",Range(0,360)) = 27
        _GustWindScale("Gust Scale",Range(0,1)) = 1
        _WindEffect("Gust Effect",Range(0,1)) = 0.2
        _GustWindspeed("Gust Speed",Range(0,1)) = 0.3

        _WindDirectionX("风X轴方向(Wind X Direction)",vector)         = (1,0,0,0)       
        _WindDirectionY("风Z轴方向(Wind Z Direction)",vector)         = (0,0,1,0)
        _WindGustWorldScale("风力贴图缩放比例(Wind gust world scale)",float)                =100
        _WindSpeed("纵向风变化速度(Wind Speed)",Range(-1,1))  = 1
        _WindHorizontalSpeed("横向风变化速度(Wind Horizontal Speed)",Range(-1,1)) = 0.25
        

        [Header(LEVEL 1)] 
        _Level1_MotionDampingFalloffRadius("物体弹性(Dampening Raidus Multiplier)",Range(0.01,100)) = 1
        _Level1_WindGustAngleRotation("最大旋转(Max Rotation)",Range(0,10))                =1
        _Level1_RandomRotationTextureSampleScale("随机摇摆贴图缩放比例(Random Rotation Chagne Rate)",float)                 = 1
        _Level1_RandomRotationInfluence("随机摇摆力度(Random Rotation Infulence)",Range(0,10))                = 1
        _Level1_WindShelterSettings("Wind 1 Shelter x: basis y: multiplier",vector)  =(-1,-0.4,0,0)              
        _Level1_ParentRotationInfluence("父节点旋转影响系数",float)                =0		
        _Level1_WindGustOffset("风力校准(Wind Angle Offset)",Range(-2,2))                =0
        _Level1_LocalWindScale("风力缩放(Local wind scale)",Range(-20,20))                =1
        


        
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200
        cull off
        CGINCLUDE

        float4 _Color_var;
        float4 _EmissionColor_var ;
        float4 _EmissionColorNear_var ;

        float4 _EmissionColor;
        float4 _EmissionColorNear;
        float _MetricScale;
        float _Debug;
        float _ShowDebug;
        float3 _WindDirectionX;
        float3 _WindDirectionY;
        float _WindSpeed;//0.25
        float _WindHorizontalSpeed;//1
        float _WindGustWorldScale;//1

        float2 _Level1_WindShelterSettings;	
        float _Level1_RandomRotationTextureSampleScale;
        float _Level1_RandomRotationInfluence;
        float _Level1_ParentRotationInfluence;
        float _Level1_WindGustAngleRotation;
        float _Level1_WindGustOffset;
        float _Level1_MotionDampingFalloffRadius;//dampening radius
        float _Level1_CamDistanceStrengthWeight;
        float _Level1_CamDistanceStrengthRange;
        
        float _Level1_LocalWindScale;


        float4 _WorldToHeatMap;
        float3 _LookAt;
        sampler2D _WindTex;

        sampler2D _HeatMap;
        float _HeatMapSampleScale;
        float _MaxSenseDistance;
        
        ENDCG
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert alphatest:_CutOut addshadow
        
        
        #pragma target 5.0

        sampler2D _MainTex;
        
        sampler2D _NormalMap;
        struct Input {
            float3 randomColor1;
            float3 randomColor2;
            float l;
            float excitation;
            float3 worldPivotPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        #include "PivotPainter2.cginc"

        void surf (Input IN, inout SurfaceOutputStandard o) {
            // Albedo comes from a texture tinted by color
            
            o.Albedo = lerp(_Color, _Color_var, saturate(IN.randomColor1.r));
            float3 emission1 = (IN.l-1)*lerp(_EmissionColorNear_var , _EmissionColor_var, saturate(IN.excitation));
            float3 emission2 = (IN.l-1)*lerp(_EmissionColorNear , _EmissionColor, saturate(IN.excitation));
            o.Emission = lerp(emission1, emission2, 1);
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;


            // o.Albedo =  tex2D(_HeatMap, (IN.worldPivotPos.xz+_WorldToHeatMap.zw)*_WorldToHeatMap.xy);

        }

        float4 SampleMip0( sampler2D smp, float2 uv)
        {						
            return tex2Dlod(smp,float4(uv,0,0));
        }
        
        float3 RotateAboutAxis(float4 NormalizedRotationAxisAndAngle, float3 PositionOnAxis, float3 Position)
        {
            // Project Position onto the rotation axis and find the closest point on the axis to Position
            float3 ClosestPointOnAxis = PositionOnAxis + NormalizedRotationAxisAndAngle.xyz * dot(NormalizedRotationAxisAndAngle.xyz, Position - PositionOnAxis);
            // Construct orthogonal axes in the plane of the rotation
            float3 UAxis = Position - ClosestPointOnAxis;
            float3 VAxis = cross(NormalizedRotationAxisAndAngle.xyz, UAxis);
            float CosAngle;
            float SinAngle;
            sincos(NormalizedRotationAxisAndAngle.w, SinAngle, CosAngle);
            // Rotate using the orthogonal axes
            float3 R = UAxis * CosAngle + VAxis * SinAngle;
            // Reconstruct the rotated world space position
            float3 RotatedPosition = ClosestPointOnAxis + R;
            // Convert from position to a position offset
            return RotatedPosition - Position;
        }


        struct PPFAParams
        {
            float3 worldPivotPos;
            float2 uv0;
            float4 xAxisAndExtent;
            float3 windDirectionX;
            float3 windDirectionY;
            float2 windShelterSettings;
            float windSpeed;//0.25
            float windHorizontalSpeed;//1
            float windGustWorldScale;//1
            float time;
            float randomRotationTextureSampleScale;
            float randomRotationInfluence;
            float layerMask;
            float parentRotationInfluence;
            float windGustAngleRotation;
            float windGustOffset;
            float motionDampingFalloffRadius;
            float CamDistanceStrengthWeight;
            float CamDistanceStrengthRange;
            float3 worldPos;
            float localWindScale;
            float parentRotation;
            float excitation;

        };
        struct PPFAOutput
        {
            float3 worldPosFinal;
            float3 worldPosOffset;
            float3 rotatedWorldSPacePixelNormal;
            float rotationAngleAnimation;
            float3 pivotPos;
            float4 rotAxis;
            float4 debug;

        };

        void SpaceLeachAnimation( in PPFAParams params, out PPFAOutput output)
        {
			output = (PPFAOutput)0;
			float3 worldPivotPos = params.worldPivotPos;
			float3 worldPos = params.worldPos;
			float3 xAxis = params.xAxisAndExtent.xyz;//float3(0,1,0);
			float xExtent = params.xAxisAndExtent.a;

			float3 tipOffset = xAxis * xExtent;
			float3 worldTipPos = worldPivotPos+tipOffset;
			half3  dpos = _WorldSpaceCameraPos - worldPos;
			float CamDistance = length(dpos);

			float directionalWindMask = (dot(xAxis, params.windDirectionX)+params.windShelterSettings.x)*params.windShelterSettings.y;


			//ambient wind
			//transform world tip pos using wind x, y axises as biases
			float2 worldTipToWind = float2(dot(params.windDirectionX,worldTipPos),dot(params.windDirectionY,worldTipPos));
			float2 windUV = float2(params.windSpeed * params.localWindScale, params.windHorizontalSpeed)*params.time + worldTipToWind/params.windGustWorldScale;
			
			float gustStrength = SampleMip0(_WindTex, frac(windUV)).a;
			//angle rotation
			float3 randomAngleRotationAxis = (SampleMip0( _WindTex,  windUV/params.randomRotationTextureSampleScale)-0.5)*params.randomRotationInfluence;
			float3 angleRotationAxis = cross( xAxis , params.windDirectionX );//todo: need to protet cross from returning 0
			angleRotationAxis = normalize(randomAngleRotationAxis + angleRotationAxis);

            
            float3 attractorAngleRotationAxis = normalize(cross(normalize( _LookAt - worldPivotPos )*float3(1,0,1), float3(0,1,0)));
            float mixValue = saturate(normalize( _LookAt - worldPivotPos )/_MaxSenseDistance);
            mixValue = smoothstep(0.6,1.0,mixValue);
            angleRotationAxis =  lerp(  angleRotationAxis,attractorAngleRotationAxis,params.excitation);
            params.windGustAngleRotation = lerp(params.windGustAngleRotation,7,params.excitation);
			float3 windTurbur;
			float angleOffsetAndMagnitute = params.windGustAngleRotation*(params.windGustOffset+gustStrength);
			//angleOffsetAndMagnitute = (1-smoothstep(params.CamDistanceStrengthRange, 0.0, CamDistance) * params.CamDistanceStrengthWeight) * angleOffsetAndMagnitute;
			output.rotationAngleAnimation = directionalWindMask * (0 + angleOffsetAndMagnitute);
			

			float motionMask = saturate(dot((worldPos - worldPivotPos), xAxis)/(params.motionDampingFalloffRadius*1.52));

			float3 rotOffset = RotateAboutAxis(float4(angleRotationAxis,motionMask* output.rotationAngleAnimation), worldPivotPos, worldPos );
			
			output.worldPosOffset = rotOffset ;
			output.pivotPos = worldPivotPos;
			output.debug.xyz = xAxis;
			output.debug.w = xExtent;
			output.rotAxis =float4(angleRotationAxis, motionMask*output.rotationAngleAnimation);

        }



        const float PHI = 1.61803398874989484820459; // Φ = Golden Ratio 

        float gold_noise(in float2 xy, in float seed)
        {
            return frac(tan(distance(xy*PHI, xy)*seed)*xy.x);
        }
        

        float3 RandomColorVariation(float2 xy, float seed)
        {
            return float3(gold_noise(xy,seed),gold_noise(xy,seed+394),gold_noise(xy,seed+40.19));
        }
        void PivotPainterVertex (inout appdata_full v, out Input SurfaceInput) 
        {
            static const int4 pivotIndices[4]={int4(0,0,0,0),int4(1,0,0,0),int4(2,1,0,0),int4(3,2,1,0)};					
            Hierachy hierachy ;//= (Hierachy)0;
            RebuildHierachy(v.texcoord1,_posAndIndexTex_TexelSize.zw,hierachy);

            hierachy.level = 0;// force one level hierachy
            float mask1 = saturate(hierachy.level);
            float mask2 = saturate(hierachy.level-1);
            float mask3 = saturate(hierachy.level-2);
            float3 instanceWorldPos = mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz;//the 4th row
            
            float extentScale = 1.;
            SurfaceInput.l = 1;
            
            float3 PivotPos = ConvertCoord(SamplePivotAndIndex(hierachy.pivotUVs[pivotIndices[hierachy.level][0]]).xyz);
            float3 worldPivotPos = mul(unity_ObjectToWorld, float4((ConvertCoord(SamplePivotAndIndex(hierachy.pivotUVs[pivotIndices[hierachy.level][0]]).xyz)),1));
            SurfaceInput.randomColor1 = saturate(RandomColorVariation(worldPivotPos.xz, 12332));
            SurfaceInput.randomColor2 = saturate( RandomColorVariation(worldPivotPos.xz, 89332));
            float excitation = SampleMip0( _HeatMap, (worldPivotPos.xz+_WorldToHeatMap.zw)*_WorldToHeatMap.xy);
            SurfaceInput.excitation = excitation;
            SurfaceInput.worldPivotPos = worldPivotPos;
            float2 offset = float2(gold_noise(worldPivotPos.xz,339)-0.5,gold_noise(worldPivotPos.xz,339)-0.5);
            v.vertex.xyz += float3(offset.x, 0, offset.y);
            {
                float3 Pos = v.vertex;
                float4 vande = SampleXVectorAndExtent(hierachy.extentUVs[pivotIndices[hierachy.level].x]);
                float3 xAxis = DecodeAxisVectorLocal(vande.rgb);				
                float xExtent = Decode8BitAlphaAxisExtent(vande.a);		
                float l = dot((Pos - PivotPos), xAxis);
                extentScale = gold_noise(worldPivotPos.xz,339)*0.5+0.5;
                v.vertex.xyz += xAxis * extentScale*l;
                Pos = v.vertex;
                float3 ringCenter = xAxis*l + PivotPos + float3(offset.x,0,offset.y);
                float t = _Time.y*(0.25+gold_noise(worldPivotPos.xz, 13.3)*.2)+gold_noise(worldPivotPos.xz, 0.3);
                float x = l/(4+gold_noise(worldPivotPos.xz,20)*2);
                float s = smoothstep(0.1,0.,abs(frac(x-t)-0.5))+1;
                s = lerp(1, s, excitation);
                v.vertex.xyz = (Pos - ringCenter)*s+ringCenter;
                SurfaceInput.l = s;
                

            }

            float3 worldPos = mul(unity_ObjectToWorld, v.vertex);

            PPFAParams ppInput1;
            ppInput1 = (PPFAParams)0;
            float4 vande = SampleXVectorAndExtent(hierachy.extentUVs[pivotIndices[hierachy.level].x]);
            float3 xAxis = DecodeAxisVector(vande.rgb);				
            float xExtent = Decode8BitAlphaAxisExtent(vande.a)*extentScale;		
            
            ppInput1.xAxisAndExtent = float4(xAxis,xExtent);
            ppInput1.time = _Time.y;
            ppInput1.worldPos = worldPos;
            ppInput1.worldPivotPos = mul(unity_ObjectToWorld, float4((ConvertCoord(SamplePivotAndIndex(hierachy.pivotUVs[pivotIndices[hierachy.level][0]]).xyz)),1));
            

            ppInput1.windDirectionX = _WindDirectionX;
            ppInput1.windDirectionY = _WindDirectionY;
            ppInput1.windSpeed = _WindSpeed;
            ppInput1.windHorizontalSpeed = _WindHorizontalSpeed;
            ppInput1.windGustWorldScale = _WindGustWorldScale;
            

            ppInput1.localWindScale						 = 		_Level1_LocalWindScale;
            ppInput1.windShelterSettings = 						_Level1_WindShelterSettings;
            ppInput1.randomRotationTextureSampleScale = 		_Level1_RandomRotationTextureSampleScale;
            ppInput1.randomRotationInfluence = 					_Level1_RandomRotationInfluence;
            ppInput1.parentRotationInfluence = 					_Level1_ParentRotationInfluence;
            ppInput1.windGustAngleRotation = 					_Level1_WindGustAngleRotation;
            ppInput1.windGustOffset = 							_Level1_WindGustOffset;
            ppInput1.motionDampingFalloffRadius = 				_Level1_MotionDampingFalloffRadius*xExtent;
            ppInput1.CamDistanceStrengthWeight = 				_Level1_CamDistanceStrengthWeight;
            ppInput1.CamDistanceStrengthRange = 				_Level1_CamDistanceStrengthRange;
            ppInput1.excitation = excitation;

            
            PPFAOutput ppOutput1;
            SpaceLeachAnimation( ppInput1, ppOutput1);

            


            // rotate the tangent frame

            float3 nn = mul(unity_ObjectToWorld,  float4(v.normal.xyz,0) );   
            nn += RotateAboutAxis(ppOutput1.rotAxis, float3(0,0,0), nn );
            nn = mul(unity_WorldToObject, float4(nn,0));
            v.normal.xyz = nn;
            
            float3 tt = mul(unity_ObjectToWorld,  float4(v.tangent.xyz,0) );
            tt += RotateAboutAxis(ppOutput1.rotAxis, float3(0,0,0), tt );
            tt = mul(unity_WorldToObject, float4(tt,0));
            v.tangent.xyz = tt;
            
            worldPos += ppOutput1.worldPosOffset;
            
            v.vertex.xyz = mul(unity_WorldToObject, float4(worldPos,1));
            
        }

        void vert(inout appdata_full v, out Input SurfaceInput) {
            
            PivotPainterVertex(v,SurfaceInput);
        }		
        ENDCG
    }
    FallBack "Diffuse"
}
