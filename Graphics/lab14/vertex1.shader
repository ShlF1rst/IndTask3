#version 330 core
layout(location = 0) in vec3 position;
layout(location = 1) in vec3 normal;
layout(location = 2) in vec2 texcoord;

uniform struct Transform {
mat4 model;
mat4 viewProjection;
mat3 normal;
vec3 viewPosition;
} transform;

uniform struct PointLight {
vec4 position;
vec4 ambient;
vec4 diffuse;
vec4 specular;
vec3 attenuation;
} light;

uniform struct Material {
	vec4 ambient;
	vec4 diffuse;
	vec4 specular;
	vec4 emission;
	float shiness;
} material;

out vec4 ourColor;

void main()
{
    vec4 vertex = transform.model * vec4(position, 1.0f);
	vec4 lightDir = light.position - vertex;
    gl_Position = transform.viewProjection * vertex;
    vec3 Vnormal = transform.normal * normal;
	vec3 VlightDir = vec3(lightDir);
	vec3 VviewDir = transform.viewPosition - vec3(vertex);
    float Vdistance = length(lightDir);
    
    vec3 fnormal = normalize(Vnormal);
	vec3 flightDir = normalize(VlightDir);
	vec3 viewDir = normalize(VviewDir);
    
    float attenuation = 1.0 / (light.attenuation[0] + light.attenuation[1] * Vdistance + light.attenuation[2] * Vdistance*Vdistance);
	ourColor = material.emission;
	ourColor += material.ambient*light.ambient*attenuation;
	float Ndot = max(dot(fnormal, flightDir), 0.0);
	ourColor += material.diffuse*light.diffuse*Ndot*attenuation;
	float RdotVpow = max(pow(dot(reflect(-flightDir, fnormal), viewDir), material.shiness), 0.0);
	ourColor += material.specular*light.specular*RdotVpow*attenuation;
}