shader_type spatial;
render_mode blend_mix, depth_prepass_alpha, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2D albedo_tex;
uniform vec4 albedo_color : source_color = vec4(1.0);
uniform float roughness : hint_range(0.0,1.0) = 0.6;
uniform float metallic  : hint_range(0.0,1.0) = 0.0;

uniform sampler2D noise_tex;
uniform float threshold : hint_range(0.0,1.0) = 0.0;
uniform float edge_width : hint_range(0.0,0.5) = 0.08;
uniform bool  invert_noise = false;

uniform float noise_scale = 1.0;
uniform vec2  noise_scroll = vec2(0.0, 0.0);

uniform vec3  edge_color : source_color = vec3(1.0, 0.5, 0.1);
uniform float edge_emission_strength : hint_range(0.0,10.0) = 3.0;

uniform float soft_dither : hint_range(0.0,1.0) = 0.0;

uniform float uv_scale = 1.0;
uniform vec2  uv_offset = vec2(0.0);

uniform vec3  fill_color : source_color = vec3(0.0);

float hash12(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

void fragment() {
    vec2 uv_base = UV * uv_scale + uv_offset;
    vec4 base = texture(albedo_tex, uv_base) * albedo_color;

    vec2 uv_noise = UV * noise_scale + noise_scroll * TIME;
    float n = texture(noise_tex, uv_noise).r;
    if (invert_noise) n = 1.0 - n;

    float t = threshold;
    if (soft_dither > 0.0) {
        float jitter = (hash12(SCREEN_UV * VIEWPORT_SIZE) - 0.5) * 0.01 * soft_dither;
        t = clamp(threshold + jitter, 0.0, 1.0);
    }

    // Cut mask: 0 = dissolved area, 1 = intact surface
    float intact = step(t, n);

    // Edge mask for glow
    float edge = 1.0 - smoothstep(t, t + max(edge_width, 1e-5), n);

    // Mix base color toward fill_color (black) in dissolved regions
    vec3 color = mix(fill_color, base.rgb, intact);

    ALBEDO = color;
    ALPHA  = base.a;
    ROUGHNESS = roughness;
    METALLIC  = metallic;

    EMISSION = edge_color * edge * edge_emission_strength;
}