// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "custom/Water" {
	Properties {
	
		_MainTex("Texture", 2D) = "white"{}
		_NormalTex("Normal",2D) = "white"{}
		_Color("Color",COLOR) = (1,1,1,1)
		_Specular("_Specular Color",COLOR) = (1,1,1,1)
        _Gloss("Glorss",Range(8.0,256)) = 20
	}
 
	SubShader
	{
		Pass
		{		
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
			};
 
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
            fixed4 _Specular;
            half _Gloss;
 
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv,_MainTex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				return o;
			}
 
			fixed4 frag(v2f i) :SV_Target
			{
				fixed4 texColor = tex2D(_MainTex,i.uv);
				fixed3 worldNormal = normalize(i.worldNormal);

				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 albedo = texColor.rgb *_Color.rgb; //自发光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;//环境光
				fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir));//漫反射
				//高光反色
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                fixed3 halfDir = normalize(worldLightDir + viewDir);
                fixed3 spacular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

				return fixed4(ambient + diffuse + spacular,1.0);//混合
			}	
 
			ENDCG
		}
	}
 
	FallBack "Diffuse"
}