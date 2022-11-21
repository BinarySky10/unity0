// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// 漫反射光照

Shader "Custom/DiffuseVertexLevel"
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
            fixed4 _Color;

            //使用一个结构体来定义顶点着色器的输入
            struct a2v {
                //POSITION语义告诉Unity 用模型空间的顶点坐标填充vertex变量
                float4 vertex : POSITION;
                float3 normal: NORMAL;
            };
            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 color : COLOR;
            };

            v2f vert(a2v v) {
                v2f o;
                //pos
                o.pos = UnityObjectToClipPos(v.vertex);
                //color
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                // // 到模型空间到世界空间的变换矩阵的逆矩阵_World20bject
                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));//世界法线???
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);//世界光
                
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
                o.color = ambient + diffuse;

                return o;
            }
            fixed4 frag(v2f i) : SV_Target {
                return fixed4(i.color, 1.0);
            }
            ENDCG
        }
    }
}
