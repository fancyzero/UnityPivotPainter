Shader "PivotPainter2/PigHair_Surface" {
	Properties {

		_MetricScale("metric scale",float)=0.01
		_Color ("Color", Color) = (1,1,1,1)
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
		

		[Header(LEVEL 2)]
		_Level2_Affected_ByParentRotation("受父节点旋转影响",float)                =1
		_Level2_MotionDampingFalloffRadius("物体弹性(Dampening Raidus Multiplier)",Range(0.01,100)) = 1
		_Level2_WindGustAngleRotation("最大旋转(Max Rotation)",Range(0,10))                =1
		_Level2_RandomRotationTextureSampleScale("随机摇摆贴图缩放比例(Random Rotation Chagne Rate)",float)                 = 1
		_Level2_RandomRotationInfluence("随机摇摆力度(Random Rotation Infulence)",Range(0,10))                = 1
		_Level2_WindShelterSettings("Wind 1 Shelter x: basis y: multiplier",vector)  =(-1,-0.4,0,0)              
		_Level2_ParentRotationInfluence("父节点旋转影响系数",float)                =0		
		_Level2_WindGustOffset("风力校准(Wind Angle Offset)",Range(-2,2))                =0
		_Level2_LocalWindScale("风力缩放(Local wind scale)",Range(-20,20))                =1
		

		[Header(LEVEL 3)]
		_Level3_Affected_ByParentRotation("受父节点旋转影响",float)                =1
		_Level3_MotionDampingFalloffRadius("物体弹性(Dampening Raidus Multiplier)",Range(0.01,100)) = 1
		_Level3_WindGustAngleRotation("最大旋转(Max Rotation)",Range(0,10))                =1
		_Level3_RandomRotationTextureSampleScale("随机摇摆贴图缩放比例(Random Rotation Chagne Rate)",float)                 = 1
		_Level3_RandomRotationInfluence("随机摇摆力度(Random Rotation Infulence)",Range(0,10))                = 1
		_Level3_WindShelterSettings("Wind 1 Shelter x: basis y: multiplier",vector)  =(-1,-0.4,0,0)              
		_Level3_ParentRotationInfluence("父节点旋转影响系数",float)                =0		
		_Level3_WindGustOffset("风力校准(Wind Angle Offset)",Range(-2,2))                =0
		_Level3_LocalWindScale("风力缩放(Local wind scale)",Range(-20,20))                =1

		[Header(LEVEL 4)]
		_Level4_Affected_ByParentRotation("受父节点旋转影响",float)                =1
		_Level4_MotionDampingFalloffRadius("物体弹性(Dampening Raidus Multiplier)",Range(0.01,100)) = 1
		_Level4_WindGustAngleRotation("最大旋转(Max Rotation)",Range(0,10))                =1
		_Level4_RandomRotationTextureSampleScale("随机摇摆贴图缩放比例(Random Rotation Chagne Rate)",float)                 = 1
		_Level4_RandomRotationInfluence("随机摇摆力度(Random Rotation Infulence)",Range(0,10))                = 1
		_Level4_WindShelterSettings("Wind 1 Shelter x: basis y: multiplier",vector)  =(-1,-0.4,0,0)              
		_Level4_ParentRotationInfluence("父节点旋转影响系数",float)                =0		
		_Level4_WindGustOffset("风力校准(Wind Angle Offset)",Range(-2,2))                =0		
		_Level4_LocalWindScale("风力缩放(Local wind scale)",Range(-20,20))                =1

		
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		cull off
		CGINCLUDE
		
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
		float _Level2_LocalWindScale;
		float _Level3_LocalWindScale;
		float _Level4_LocalWindScale;

		float2 _Level2_WindShelterSettings;	
		float _Level2_RandomRotationTextureSampleScale;
		float _Level2_RandomRotationInfluence;
		float _Level2_ParentRotationInfluence;
		float _Level2_WindGustAngleRotation;
		float _Level2_WindGustOffset;
		float _Level2_MotionDampingFalloffRadius;//dampening radius
		float _Level2_CamDistanceStrengthWeight;
		float _Level2_CamDistanceStrengthRange;
		float _Level2_Affected_ByParentRotation;

		float2 _Level3_WindShelterSettings;	
		float _Level3_RandomRotationTextureSampleScale;
		float _Level3_RandomRotationInfluence;
		float _Level3_ParentRotationInfluence;
		float _Level3_WindGustAngleRotation;
		float _Level3_WindGustOffset;
		float _Level3_MotionDampingFalloffRadius;//dampening radius
		float _Level3_Affected_ByParentRotation;
		float _Level3_CamDistanceStrengthWeight;
		float _Level3_CamDistanceStrengthRange;

		float2 _Level4_WindShelterSettings;	
		float _Level4_RandomRotationTextureSampleScale;
		float _Level4_RandomRotationInfluence;
		float _Level4_ParentRotationInfluence;
		float _Level4_WindGustAngleRotation;
		float _Level4_WindGustOffset;
		float _Level4_MotionDampingFalloffRadius;//dampening radius
		float _Level4_Affected_ByParentRotation;
		float _Level4_CamDistanceStrengthWeight;
		float _Level4_CamDistanceStrengthRange;	


		sampler2D _WindTex;

		
		
		ENDCG
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert alphatest:_CutOut addshadow
		
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		
		sampler2D _NormalMap;
		struct Input {
			float2 uv_MainTex;
            float3 pivotPos;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		#include "PivotPainter2.cginc"

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = frac(IN.pivotPos.xyz*100)*c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Normal = UnpackNormal (tex2D (_NormalMap, IN.uv_MainTex));
			o.Alpha = c.a;
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

		void PovitPainter2FoliageAnimation( in PPFAParams params, out PPFAOutput output)
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


		struct DebugOutput
		{
			float4 info;
			float4 info1;
			float4 info2;
			float4 info3;
			float4 info4;
			float4 info5;
			float4 info6;
			float4 info7;
		};


		DebugOutput PivotPainterVertex (inout appdata_full v) 
		{
			static const int4 pivotIndices[4]={int4(0,0,0,0),int4(1,0,0,0),int4(2,1,0,0),int4(3,2,1,0)};					
			DebugOutput ret = (DebugOutput)0;
			Hierachy hierachy ;//= (Hierachy)0;
			RebuildHierachy(v.texcoord1,_posAndIndexTex_TexelSize.zw,hierachy);
			hierachy.level = 0;// force one level hierachy
			float mask1 = saturate(hierachy.level);
			float mask2 = saturate(hierachy.level-1);
			float mask3 = saturate(hierachy.level-2);
			float3 instanceWorldPos = mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz;//the 4th row
			float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
			
			
			PPFAParams ppInput1;
			ppInput1 = (PPFAParams)0;
			float4 vande = SampleXVectorAndExtent(hierachy.extentUVs[pivotIndices[hierachy.level].x]);
			float3 xAxis = DecodeAxisVector(vande.rgb);				
			float xExtent = Decode8BitAlphaAxisExtent(vande.a);		
			
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
			ppInput1.motionDampingFalloffRadius = 				_Level1_MotionDampingFalloffRadius;
			ppInput1.CamDistanceStrengthWeight = 				_Level1_CamDistanceStrengthWeight;
			ppInput1.CamDistanceStrengthRange = 				_Level1_CamDistanceStrengthRange;


			
			PPFAOutput ppOutput1;
			PovitPainter2FoliageAnimation( ppInput1, ppOutput1);

			

			PPFAParams ppInput2;
			ppInput2 = (PPFAParams)0;
			vande = SampleXVectorAndExtent(hierachy.extentUVs[pivotIndices[hierachy.level].y]);
			xAxis = DecodeAxisVector(vande.rgb);				
			xExtent = Decode8BitAlphaAxisExtent(vande.a);					
			ppInput2.xAxisAndExtent = float4(xAxis,xExtent);
			ppInput2.time = _Time.y;
			ppInput2.worldPos = worldPos;
			ppInput2.worldPivotPos =  mul(unity_ObjectToWorld, float4((ConvertCoord(SamplePivotAndIndex(hierachy.pivotUVs[pivotIndices[hierachy.level][1]]).xyz)),1));
			ppInput2.windDirectionX = _WindDirectionX;
			ppInput2.windDirectionY = _WindDirectionY;
			ppInput2.windSpeed = _WindSpeed;
			ppInput2.windHorizontalSpeed = _WindHorizontalSpeed;
			ppInput2.windGustWorldScale = _WindGustWorldScale;

			ppInput2.localWindScale						 = 		_Level2_LocalWindScale;
			ppInput2.windShelterSettings = _Level2_WindShelterSettings;
			ppInput2.randomRotationTextureSampleScale = _Level2_RandomRotationTextureSampleScale;
			ppInput2.randomRotationInfluence = _Level2_RandomRotationInfluence;
			ppInput2.parentRotationInfluence = _Level2_Affected_ByParentRotation* ppOutput1.rotationAngleAnimation;
			ppInput2.windGustAngleRotation = _Level2_WindGustAngleRotation;
			ppInput2.windGustOffset = _Level2_WindGustOffset;
			ppInput2.motionDampingFalloffRadius = _Level2_MotionDampingFalloffRadius;
			ppInput2.CamDistanceStrengthWeight = _Level2_CamDistanceStrengthWeight;
			ppInput2.CamDistanceStrengthRange = _Level2_CamDistanceStrengthRange;

			PPFAOutput ppOutput2;
			PovitPainter2FoliageAnimation( ppInput2, ppOutput2);


			PPFAParams ppInput3;
			ppInput3 = (PPFAParams)0;
			vande = SampleXVectorAndExtent(hierachy.extentUVs[pivotIndices[hierachy.level].z]);
			xAxis = DecodeAxisVector(vande.rgb);				
			xExtent = Decode8BitAlphaAxisExtent(vande.a);					
			ppInput3.xAxisAndExtent = float4(xAxis,xExtent);
			ppInput3.time = _Time.y;
			ppInput3.worldPos = worldPos;
			ppInput3.worldPivotPos =  mul(unity_ObjectToWorld, float4((ConvertCoord(SamplePivotAndIndex(hierachy.pivotUVs[pivotIndices[hierachy.level][2]]).xyz)),1));
			ppInput3.windDirectionX = _WindDirectionX;
			ppInput3.windDirectionY = _WindDirectionY;
			ppInput3.windSpeed = _WindSpeed;
			ppInput3.windHorizontalSpeed = _WindHorizontalSpeed;
			ppInput3.windGustWorldScale = _WindGustWorldScale;

			ppInput3.localWindScale						 = 		_Level3_LocalWindScale;
			ppInput3.windShelterSettings = _Level3_WindShelterSettings;
			ppInput3.randomRotationTextureSampleScale = _Level3_RandomRotationTextureSampleScale;
			ppInput3.randomRotationInfluence = _Level3_RandomRotationInfluence;
			ppInput3.parentRotationInfluence = _Level3_Affected_ByParentRotation* ppOutput1.rotationAngleAnimation;
			ppInput3.windGustAngleRotation = _Level3_WindGustAngleRotation;
			ppInput3.windGustOffset = _Level3_WindGustOffset;
			ppInput3.motionDampingFalloffRadius = _Level3_MotionDampingFalloffRadius;
			ppInput3.CamDistanceStrengthWeight = _Level3_CamDistanceStrengthWeight;
			ppInput3.CamDistanceStrengthRange = _Level3_CamDistanceStrengthRange;

			PPFAOutput ppOutput3;
			PovitPainter2FoliageAnimation( ppInput3, ppOutput3);


			PPFAParams ppInput4;
			ppInput4 = (PPFAParams)0;
			vande = SampleXVectorAndExtent(hierachy.extentUVs[pivotIndices[hierachy.level].w]);
			xAxis = DecodeAxisVector(vande.rgb);				
			xExtent = Decode8BitAlphaAxisExtent(vande.a);					
			ppInput4.xAxisAndExtent = float4(xAxis,xExtent);
			ppInput4.time = _Time.y;
			ppInput4.worldPos = worldPos;
			ppInput4.worldPivotPos =  mul(unity_ObjectToWorld, float4((ConvertCoord(SamplePivotAndIndex(hierachy.pivotUVs[pivotIndices[hierachy.level][3]]).xyz)),1));
			ppInput4.windDirectionX = _WindDirectionX;
			ppInput4.windDirectionY = _WindDirectionY;
			ppInput4.windSpeed = _WindSpeed;
			ppInput4.windHorizontalSpeed = _WindHorizontalSpeed;
			ppInput4.windGustWorldScale = _WindGustWorldScale;


			ppInput4.localWindScale						 = 		_Level4_LocalWindScale;
			ppInput4.windShelterSettings = _Level4_WindShelterSettings;
			ppInput4.randomRotationTextureSampleScale = _Level4_RandomRotationTextureSampleScale;
			ppInput4.randomRotationInfluence = _Level4_RandomRotationInfluence;
			ppInput4.parentRotationInfluence = _Level4_Affected_ByParentRotation* ppOutput1.rotationAngleAnimation;
			ppInput4.windGustAngleRotation = _Level4_WindGustAngleRotation;
			ppInput4.windGustOffset = _Level4_WindGustOffset;
			ppInput4.motionDampingFalloffRadius = _Level4_MotionDampingFalloffRadius;
			ppInput4.CamDistanceStrengthWeight = _Level4_CamDistanceStrengthWeight;
			ppInput4.CamDistanceStrengthRange = _Level4_CamDistanceStrengthRange;

			PPFAOutput ppOutput4;
			PovitPainter2FoliageAnimation( ppInput4, ppOutput4);

			// rotate the tangent frame

			float3 nn = mul(unity_ObjectToWorld,  float4(v.normal.xyz,0) );   
			nn += RotateAboutAxis(ppOutput1.rotAxis, float3(0,0,0), nn );
			nn += RotateAboutAxis(ppOutput2.rotAxis, float3(0,0,0), nn )*mask1;
			nn += RotateAboutAxis(ppOutput3.rotAxis, float3(0,0,0), nn )*mask2;
			nn += RotateAboutAxis(ppOutput4.rotAxis, float3(0,0,0), nn )*mask3;
			nn = mul(unity_WorldToObject, float4(nn,0));
			v.normal.xyz = nn;
			
			float3 tt = mul(unity_ObjectToWorld,  float4(v.tangent.xyz,0) );
			tt += RotateAboutAxis(ppOutput1.rotAxis, float3(0,0,0), tt );
			tt += RotateAboutAxis(ppOutput2.rotAxis, float3(0,0,0), tt )*mask1;
			tt += RotateAboutAxis(ppOutput3.rotAxis, float3(0,0,0), tt )*mask2;
			tt += RotateAboutAxis(ppOutput4.rotAxis, float3(0,0,0), tt )*mask3;
			tt = mul(unity_WorldToObject, float4(tt,0));
			v.tangent.xyz = tt;
			
			worldPos += ppOutput1.worldPosOffset+ppOutput2.worldPosOffset*mask1+ppOutput3.worldPosOffset*mask2+ppOutput4.worldPosOffset*mask3;
			
			v.vertex.xyz = mul(unity_WorldToObject, float4(worldPos,1));

			ret.info = ppInput1.worldPivotPos.xyzz;
			ret.info1 = ppInput2.worldPivotPos.xyzz;
			ret.info2 = ppInput3.worldPivotPos.xyzz;
			ret.info3 = ppInput4.worldPivotPos.xyzz;
			
			ret.info4 = ppInput1.xAxisAndExtent;
			ret.info5 = ppInput2.xAxisAndExtent;
			ret.info6 = ppInput3.xAxisAndExtent;
			ret.info7 = ppInput4.xAxisAndExtent;
			return ret;   
			
		}

		void vert(inout appdata_full v, out Input IN) {
			
			DebugOutput dbgoutput = PivotPainterVertex(v);
            IN.pivotPos = dbgoutput.info.xyz;
            IN.uv_MainTex = v.texcoord;
		}		
		ENDCG
	}
	FallBack "Diffuse"
}
