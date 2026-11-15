#version 460

// EFFECT_INTENSITY 0.0 [-2.0, 2.0]
// EFFECT_SQUARED true true|false

#ifndef EFFECT_SQUARED
    bool EFFECT_SQUARED = false;
#endif
#ifndef EFFECT_INTENSITY
    float EFFECT_INTENSITY = 1.0;
#endif

uniform sampler2D gtexture;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0; 

in vec2 TexCoord;
in vec3 foliageColor;

void main() {
    vec4 outputColorData = texture(gtexture, TexCoord);
    vec3 almostOutputColor = outputColorData.rgb * foliageColor;
    float transparency = outputColorData.a;
    if (transparency < 0.1)
    {
        discard;
    }
    float colorBuffer = (almostOutputColor.r + almostOutputColor.g + almostOutputColor.b)/3;
    vec3 averageColor = vec3(colorBuffer, colorBuffer, colorBuffer);
    vec3 outputColor;
    if (EFFECT_SQUARED)
    {
        outputColor = almostOutputColor + EFFECT_INTENSITY * averageColor * averageColor;
    } else {
        outputColor = almostOutputColor + EFFECT_INTENSITY * averageColor;
    }
    outColor0 = vec4(outputColor, transparency); //texture(gtexture, TexCoord);
}