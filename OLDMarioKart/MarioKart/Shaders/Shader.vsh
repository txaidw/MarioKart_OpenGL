//
//  Shader.vsh
//  MarioKart
//
//  Created by Txai Wieser on 10/28/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

//attribute vec4 position;
//attribute vec3 normal;
//
//varying lowp vec4 colorVarying;
//
//uniform mat4 modelViewProjectionMatrix;
//uniform mat3 normalMatrix;
//
//void main()
//{
//    vec3 eyeNormal = normalize(normalMatrix * normal);
//    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
//    vec4 diffuseColor = vec4(0.4, 0.4, 1.0, 1.0);
//    
//    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
//                 
//    colorVarying = diffuseColor * nDotVP;
//    
//    gl_Position = modelViewProjectionMatrix * position;
//}
uniform highp mat4 u_ModelViewMatrix;
uniform highp mat4 u_ProjectionMatrix;

attribute vec4 a_Position;
attribute vec4 a_Color;
attribute vec2 a_TexCoord;
attribute vec3 a_Normal;

varying lowp vec4 frag_Color;
varying lowp vec2 frag_TexCoord;
varying lowp vec3 frag_Normal;
varying lowp vec3 frag_Position;

void main(void) {
    frag_Color = a_Color;
    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * a_Position;
    frag_TexCoord = a_TexCoord;
    frag_Normal = (u_ModelViewMatrix * vec4(a_Normal, 0.0)).xyz;
    frag_Position = (u_ModelViewMatrix * a_Position).xyz;
}