shader_type spatial;

uniform float amplitude : hint_range(0, 1) = 0.1;
uniform float frequency : hint_range(0, 10) = 5.0;
uniform sampler2D albedo_texture;
uniform vec4 albedo_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D normal_map;
uniform vec3 rim_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float rim_strength : hint_range(0.0, 1.0) = 0.5;
uniform float rim_width : hint_range(0.0, 1.0) = 0.5;

void vertex() {
    float noise = amplitude * sin(TIME * frequency + VERTEX.x * 12.345 + VERTEX.y * 6.789 + VERTEX.z * 9.876);
    VERTEX += normalize(NORMAL) * noise;
}

void fragment() {
    vec4 tex_color = texture(albedo_texture, UV);
    ALBEDO = tex_color.rgb * albedo_color.rgb;
    ALPHA = tex_color.a * albedo_color.a;
	
	// Normalmap
    vec3 normal_from_map = texture(normal_map, UV).rgb;
    normal_from_map = normal_from_map * 2.0 - 1.0;
    NORMAL = mat3(TANGENT, BINORMAL, NORMAL) * normal_from_map;
	
	// Rim
	float rim = pow(1.0 - max(dot(normalize(NORMAL), normalize(VIEW)), 0.0), rim_width);
    vec3 rim_light = rim * rim_color * rim_strength;
    ALBEDO += rim_light;
}
