Shader "Custom/DiffusePixelLevel"
{
    Properties
    {
        _Diffuse("Diffuse", Color) = (1, 1, 1, 1)
    }
        SubShader
    {
        Pass {
            Tags { "LightMode" = "ForWardBase"}
            CGPROGRAM
            #include "Lighting.cginc"
            #pragma vertex vert 
            #pragma fragment frag 

            fixed4 _Diffuse;

            //使用一个结构体来定义顶点着色器的输入
            struct a2v {
                //POSITION语义告诉Unity 用模型空间的顶点坐标填充vertex变量
                float4 vertex : POSITION;
                float3 normal: NORMAL;
            };
            struct v2f {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
            };

            v2f vert(a2v v) {
                v2f o;
                //pos
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

                return o;
            }
            fixed4 frag(v2f i) : SV_Target{
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                float3 worldNormal = i.worldNormal;
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);//世界光

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
                return fixed4(ambient + diffuse, 1.0);
            }
            ENDCG
        }
    }
}
