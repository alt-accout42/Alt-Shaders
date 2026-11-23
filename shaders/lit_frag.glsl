#version 460 compatibility
//#]define INTENSITY 0.0 //[-2.0 -1.9 -1.8 -1.7 -1.6 -1.5 -1.4 -1.3 -1.2 -1.1 -1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
//#]define SQUARED 1 //[-10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10]
//  WHY DOES IT HAVE TO BE IN A COMMENT?? (unusedS)

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
uniform sampler2D specular;
/*
uniform float frameTimeCounter;
uniform int worldDay;
*/
uniform float screenBrightness;
uniform int moonPhase;
uniform mat4 gbufferModelViewInverse;
uniform vec3 shadowLightPosition;
uniform int isEyeInWater;


/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;
// if error here then a function didnt get enough args or wrong 'in'
in vec2 TexCoord;
in vec3 foliageColor;
in vec2 lightMapCoords;
in vec3 geoNormal;



float averageCol(vec3 colVec3) {
    return (colVec3.x + colVec3.y + colVec3.z)/3;
}


float colBrightness(vec3 colVec3) {
    float minBuffer = min(colVec3.x, colVec3.y);
    float minBuffer0 = min(minBuffer, colVec3.z);

    return minBuffer0;
}


float colDifrentness(vec3 colVec3) {
    float chigai = 0.0;

    chigai += abs(colVec3.x - colVec3.y);
    chigai += abs(colVec3.y - colVec3.x);
    chigai += abs(colVec3.x - colVec3.z);
    
    return chigai/1.5;
}


void main() { // TODO: OPTIMIZE THIS SPAGETTI CODE

    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
    vec3 worldGeoNormal = mat3(gbufferModelViewInverse) * geoNormal;
    float lightBrightness = clamp(dot(shadowLightDirection, worldGeoNormal), 0.2, 1.1);

    vec3 lightColor = (texture(lightmap,lightMapCoords).rgb);
    // lightColor *= (4+(2-averageCol(lightColor)))/5;
    lightColor = pow(lightColor,vec3(3.4-isEyeInWater*2-averageCol(lightColor)+colDifrentness(lightColor))); // make customizable?

    //lightColor = (lightColor - colBrightness(lightColor) / 3) * 1.5;
    
    vec4 outputColorData = texture(gtexture, TexCoord);
    outputColorData = vec4(pow((outputColorData.rgb + vec3(0.1)) / vec3(1.1), vec3(1+colDifrentness(outputColorData.rgb*0.5)+outputColorData.g)), outputColorData.a);
    vec3 almostOutputColor = outputColorData.rgb * pow(foliageColor, vec3(1.2)) * ((screenBrightness * 0.6 + 1) * lightColor * (1-outputColorData.rgb*0.2+colDifrentness(lightColor))); //  + vec3(0.3*screenBrightness)) * ((screenBrightness+0.2)*0.2+0.12 - float(abs(moonPhase-4))*0.0005)
 
    // almostOutputColor *= (4-colBrightness(almostOutputColor))/3;
    float transparency = outputColorData.a;
    if (transparency < 0.1)
    {
        discard;
    }
 
    float averageColor = averageCol(almostOutputColor);
    vec3 averageColorVec3 = vec3(averageColor, averageColor, averageColor); //    SQUARED VALUE \/
    
    vec3 outputColor = almostOutputColor + (screenBrightness-1)/3.0 * pow(averageColorVec3, vec3(2)); // ok i cant believe i didnt think of this. ive been trying to solve this for like half an hour and it turned out to be just putting vec3() to SQUARED. fgxfutryxfutdyfxydtfudzfxtrdyf
    
    // outputColor = vec3(colBrightness(outputColor)); // monochromatic
    // outputColor *= vec3(pow(log(3 - colBrightness(outputColor)), 0.2));
    
    outputColor *= vec3(1,1,1+isEyeInWater*1.5);
    // outputColor += sin(outputColor)*cos(pow(outputColor,vec3(2.0))); // experimental
    outColor0 = vec4(outputColor*((lightBrightness+1.0)/2.0), transparency); 
}