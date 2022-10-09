shader_type spatial;

uniform vec4 albedo: source_color;
uniform sampler2D normalmap;
uniform vec2 direction;

void fragment() {
	ALBEDO = albedo.rgb;
	ALPHA = 0.75;
	SPECULAR = 0.1;
	ROUGHNESS = 0.05;
	
	NORMAL_MAP = texture(normalmap, UV + direction * TIME * 0.025).xyz;
}
