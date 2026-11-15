#version 460

#define INTENSITY 0.0 //[-2.0 -1.9 -1.8 -1.7 -1.6 -1.5 -1.4 -1.3 -1.2 -1.1 -1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define SQUARED 1 //[-10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10]
//  WHY DOES IT HAVE TO BE IN A COMMENT?? 

#ifndef SQUARED
    int SQUARED = 1;
#endif
#ifndef INTENSITY
    float INTENSITY = 0.0;
#endif

uniform sampler2D gtexture;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;
// idk
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
    outputColor = almostOutputColor + INTENSITY * pow(averageColor, vec3(SQUARED)); // ok i cant believe i didnt think of this. ive been trying to solve this for like half an hour and it turned out to be just putting vec3() to squared.fgxfutryxfutdyfxydtfudzfxtrdyf
    outColor0 = vec4(outputColor, transparency); //texture(gtexture, TexCoord);
}