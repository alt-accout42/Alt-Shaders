#version 460


in vec3 vaPosition;

in vec2 vaUV0;
in vec4 vaColor;
in ivec2 vaUV2;
in vec3 vaNormal;

uniform vec3 chunkOffset;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform vec4 entityColor;
uniform int entityId;
uniform int blockEntityId;
uniform mat3 normalMatrix;

out vec2 TexCoord;
out vec3 foliageColor;
out vec3 entityCol;
out vec2 lightMapCoords;
out vec3 geoNormal;


void main() {
    TexCoord = vaUV0;

    geoNormal = normalMatrix * vaNormal;

    foliageColor = vaColor.rgb;
    // vec3 worldSpaceVertexPosition = cameraPosition + (gbufferModelViewInverse * modelViewMatrix * vec4(vaPosition+chunkOffset,1)).xyz;
    lightMapCoords = vaUV2*(1.0/256.0)+(1.0/32.0); // accidentally fixed btw (except for enities and block entities bruh)
    // float distanceFromCamera = distance(worldSpaceVertexPosition,cameraPosition);    

    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition + chunkOffset,1);
}