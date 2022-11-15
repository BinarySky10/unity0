// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Chapter5-SimpleShader"
{
    Properties
    {
        
    }
    SubShader
    {
        Pass { 
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag 

            //使用一个结构体来定义顶点着色器的输入
            struct a2v{
                //POSITION语义告诉Unity 用模型空间的顶点坐标填充vertex变量
                float4 vertex : POSITION;
                float3 normal: NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            float4 vert(a2v v) : SV_POSITION { 
                return UnityObjectToClipPos(v.vertex);
            }
            fixed4 frag() : SV_Target { 
                return fixed4(1.0, 1.0, 1.0, 1.0); 
            }
            ENDCG
            }
    }
    
}
