#version 330 core

uniform	sampler2D myTexture;
in vec2 obj_texcoord;
in vec4 ourColor;
out vec4 color;
void main()
{
	color = ourColor * texture(myTexture, obj_texcoord);
}