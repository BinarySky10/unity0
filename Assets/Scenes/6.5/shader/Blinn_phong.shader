Shader "Custom/Blinn_phong"
{
    Properties
    {
        _Diffuse("Diffuse", Color) = (1, 1, 1, 1)
        _Specular("Specular", Color) = (1, 1, 1, 1)
        _Gloss("Gloss", Range(8.0, 256)) = 20
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
            fixed4 _Specular;
            float _Gloss;

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

                //ambient
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //diffuse
                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));//世界法线???
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);//世界光

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
                //specular
                //fixed3 reflectDir = normalize(reflect(-worldLight, worldNormal));
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - o.pos);
                fixed3 halfDir = normalize(worldLight + viewDir);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);
                o.color = ambient + diffuse + specular;

                return o;
            }
            fixed4 frag(v2f i) : SV_Target {
                return fixed4(i.color, 1.0);
            }
            ENDCG
        }
    }

}
