Shader "Piotr/ObjectDisappear"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Mask("Mask",2D)="white"{}
        
        _Factor ("factor",float)=0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            struct appdata
            {
            float3 normal:NORMAL;
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color:COLOR;
            };

            sampler2D _MainTex;
            sampler2D _Mask;
            float4 _MainTex_ST;
            float _Factor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                float4 color=tex2Dlod(_MainTex,float4(v.uv.xy,0,0));
                o.color.w=1;
         
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                if(_Factor*0.1>col.b)
                discard;
                return i.color+col;
            }
            ENDCG
        }
    }
}
