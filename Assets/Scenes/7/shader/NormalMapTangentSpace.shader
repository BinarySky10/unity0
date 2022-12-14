Shader "Custom/NormalMapTangentSpace"
{
    Properties
    {
        _Color("Color Tint", Color) = (1, 1, 1, 1)
        _MainTex("Texture", 2D) = "white" {}
        _BumpMap("Normal Map", 2D) = "bump" {}
        _BumpScale("Bump Scale", Float)= 1.0
        _Specular("Specular", Color) = (1, 1, 1, 1)
        _Gloss("Gloss", Range(8.0, 256)) = 20
    }
        SubShader
        {
            Pass
            {
                Tags { "LightMode" = "ForWardBase"}

                CGPROGRAM
                #include "Lighting.cginc"
                #pragma vertex vert
                #pragma fragment frag

                fixed4 _Color;
                sampler2D _MainTex;
                float4 _MainTex_ST;
                sampler2D _BumpMap;
                float4 _BumpMap_ST;
                fixed4 _Specular;
                float _Gloss;

                struct a2v {
                    float4 vertex : POSITION;
                    float3 normal: NORMAL;
                    float4 tangent:TANGENT;
                    float4 texcoord : TEXCOORD0;
                };
                struct v2f {
                    float4 pos : SV_POSITION;//裁剪坐标
                    float4 uv : TEXCOORD0;
                    float3 lightDir : TEXCOORD1;
                    float3 viewDir: TEXCOORD2;
                    
                };

                v2f vert(a2v v) {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                    o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;

                    float3 binormal = cross(normalize(v.normal), normalize(v.tangent.xyz)) * v.tangent.w;
                    float3x3 rotation = float3x3(v.tangent.xyz, binormal, v.normal);
                    o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
                    o.ViewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;
                    //o.lightDir = mul()
                    return o;
                }
                fixed4 frag(v2f i) : SV_Target{
                    fixed3 worldNormal = normalize(i.worldNormal);
                    fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));

                    fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
                    //ambient
                    fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                    //diffuse
                    fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir));
                    //specular
                    fixed3 viewDir = normalize(i.worldPos);
                    fixed3 halfDir = normalize(worldLightDir + viewDir);

                    fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);
                    return fixed4(ambient + diffuse + specular, 1.0);
                }

                ENDCG
            }

        }
            FallBack "Specular"
}
