#version 460 compatibility


out vec2 TexCoord;
out vec3 foliageColor;


void main() {
    TexCoord = (gl_Texturematrix[1] * gl_MultiTexCoord0).xy;

    foliageColor = gl_Color.rgb;

    gl_Position = ftransform();
}