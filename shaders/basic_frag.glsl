//#]define INTENSITY 0.0 //[-2.0 -1.9 -1.8 -1.7 -1.6 -1.5 -1.4 -1.3 -1.2 -1.1 -1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
//#]define SQUARED 1 //[-10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10]
//  WHY DOES IT HAVE TO BE IN A COMMENT?? 

/*
#]ifndef SQUARED
    int SQUARED = 1;
#]endif

#]ifndef INTENSITY
    float INTENSITY = 0.0;
#]endif
*/

/*
#ifndef entityrender
    entityrender = 0.0;
#endif
*/

uniform sampler2D gtexture;
uniform sampler2D lightmap;
/*
uniform float frameTimeCounter;
uniform int worldDay;
*/
uniform float screenBrightness;
uniform int moonPhase;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;
// if error here then a function didnt get enough args or wrong 'in'
in vec2 TexCoord;
in vec3 foliageColor;
in vec2 lightMapCoords;


float averageCol(vec3 colVec3) {
    return (colVec3.x + colVec3.y + colVec3.z)/3;
}


void main() {
    vec3 lightColor = pow(texture(lightmap,lightMapCoords).rgb,vec3(5.0)); // make customizable?
    vec4 outputColorData = pow(texture(gtexture, TexCoord), vec4(1.2));
    vec3 almostOutputColor = outputColorData.rgb * foliageColor * ((screenBrightness * 3.0 + 1.0) * lightColor + vec3(0.1)) * ((screenBrightness+0.2)*0.2+0.12 - float(abs(moonPhase-4))*0.0005) ;
 
    float transparency = outputColorData.a;
    if (transparency < 0.1)
    {
        discard;
    }
 
    float averageColor = averageCol(almostOutputColor);
    vec3 averageColorVec3 = vec3(averageColor, averageColor, averageColor); //    SQUARED VALUE \/
    vec3 outputColor = almostOutputColor + (screenBrightness-1)/3.0 * pow(averageColorVec3, vec3(2)); // ok i cant believe i didnt think of this. ive been trying to solve this for like half an hour and it turned out to be just putting vec3() to SQUARED. fgxfutryxfutdyfxydtfudzfxtrdyf
    outColor0 = vec4(outputColor, transparency); 
}