#version 460


uniform sampler2D gtexture;

uniform float screenBrightness;
uniform int moonPhase;
uniform mat4 gbufferModelViewInverse;
uniform vec3 shadowLightPosition;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;
// if error here then a function didnt get enough args or wrong 'in'
in vec2 TexCoord;
in vec3 foliageColor;


float averageCol(vec3 colVec3) {
    return (colVec3.x + colVec3.y + colVec3.z)/3;
}


float colBrightness(vec3 colVec3) {
    float minBuffer = min(colVec3.x, colVec3.y);
    float minBuffer0 = min(minBuffer, colVec3.z);

    return minBuffer0;
}


void main() {

    vec4 outputColorData = pow(texture(gtexture, TexCoord), vec4(1.2));
    float transparency = outputColorData.a;
    if (transparency < 0.1)
    {
        discard;
    }
    
    outColor0 = vec4(outputColorData.rgb, transparency); 
}