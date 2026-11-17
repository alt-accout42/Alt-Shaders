#version 460 compatibility

out vec4 glcolor;
out vec4 starData;

void main() {
	gl_Position = ftransform();
    starData = vec4(gl_Color.rgb, float(gl_Color.r == gl_Color.g && gl_Color.g == gl_Color.b && gl_Color.r > 0.0));
	glcolor = gl_Color * vec4(2);
}