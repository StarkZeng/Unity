﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "custom/Wave" {
	Properties {
	
		_MainTex("Texture", 2D) = "white"{} //纹理
		_Arange("Amplitute", float) = 1
		_Frequency("Frequency", float) = 2//波动频率
		_Speed("Speed",float) = 0.5//控制纹理移动的速度
 
	}
 
	SubShader
	{
		Pass
		{		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			struct appdata
			{
				float4 vertex:POSITION;
				float2 uv:TEXCOORD0;
			};
	
			struct v2f
			{
				float2 uv:TEXCOORD0;
				float4 vertex:SV_POSITION;
			};
 
			float _Frequency;
			float _Arange;
			float _Speed;
 
			v2f vert(appdata v)
			{
			v2f o;
 
			float timer = _Time.y *_Speed;
			//变化之前做一个波动 y=  Asin（ωx+φ）
			float waver = _Arange*sin(timer + v.vertex.x *_Frequency);
			v.vertex.y = v.vertex.y + waver;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uv = v.uv;
			return o;
			}
 
			sampler2D _MainTex;
 
			fixed4 frag(v2f i) :SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}	
 
			ENDCG
		}
	}
 
	FallBack "Diffuse"
}