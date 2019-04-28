// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "custom/Water" {
	Properties {
	
		_MainTex("Texture", 2D) = "white"{}
		_NormalTex("Normal",2D) = "white"{}
		_Color("Color",COLOR) = (1,1,1,1)
		_Specular("_Specular Color",COLOR) = (1,1,1,1)
        _Gloss("Glorss",Range(1.0,256)) = 20

		_BumpDirection("BumpDirection",Vector)=(0,0,0,0)
		_BumpTiling("BumpTiling",Vector)=(0,0,0,0)
		_BumpStrength("BumpStrength",Float) = 0
	}
 
	SubShader
	{
		Tags{"Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout"}
		Cull Off
		Pass
		{	
			Tags{"LightMode" = "ForwardBase"}	
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "lighting.cginc"
			
			struct appdata
			{
				float4 vertex:POSITION;
				float2 uv:TEXCOORD0;
				float4 normal:NORMAL;
			};
	
			struct v2f
			{
				float2 uv:TEXCOORD0;
				float4 vertex:SV_POSITION;
				float3 worldNormal:TEXCOORD1;
				float3 worldPos:TEXCOORD2;
				float4 bumpCoords:TEXCOORD4;
				float3 viewVector:TEXCOORD5;
			};
 
			sampler2D _MainTex;
			sampler2D _NormalTex;
			float4 _MainTex_ST;
			fixed4 _Color;
            fixed4 _Specular;
			fixed4 _BumpTiling;
			fixed4 _BumpDirection;
			fixed _BumpStrength;
            half _Gloss;
 
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv,_MainTex);
				
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				
				o.bumpCoords.xyzw = (o.worldPos.xzxz + _Time.yyyy * _BumpDirection.xyzw) * _BumpTiling.xyzw;
				o.viewVector = o.worldPos - _WorldSpaceCameraPos.xyz;
				return o;
			}
 
			fixed4 frag(v2f i) :SV_Target
			{
				float2 bump = UnpackNormal(tex2D(_NormalTex,i.bumpCoords.xy)) + UnpackNormal(tex2D(_NormalTex,i.bumpCoords.zw));
				bump = bump * 0.5;
				half3 worldNormal  = float3(bump.x * _BumpStrength,1,bump.y * _BumpStrength);
				half2 offsets = worldNormal.xz*i.viewVector.y*1;

				half4 texColor = tex2D(_MainTex, i.uv.xy+offsets);

				// fixed4 texColor = tex2D(_MainTex,i.uv.xy);
				// fixed3 normal = UnpackNormal(tex2D(_NormalTex,i.uv.wz));
				// fixed3 worldNormal = normalize(normal);

				//fixed3 worldNormal = normalize(i.worldNormal);

				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 albedo = texColor*_Color.rgb; //自发光
				//fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;//环境光
				fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir));//漫反射
				//高光反色
				fixed3 viewDir = normalize(i.viewVector);//UnityWorldSpaceViewDir(i.worldPos));
                fixed3 halfDir = normalize(worldLightDir + viewDir);
				fixed3 spacular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

				return fixed4(spacular.rgb + albedo + diffuse,1);//混合
			}	
 
			ENDCG
		}
	}
 
	FallBack "Diffuse"
}
