shader_type spatial;

uniform float fade_start = -0.1;
uniform vec3 color = vec3(1.0);

void fragment() {
    float fade_factor = smoothstep(fade_start, 1.0, UV.y);
    ALBEDO = color;
    ALPHA = fade_factor;
}
