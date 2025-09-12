shader_type canvas_item;

uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.0;
uniform float vignette_radius: hint_range(0.1, 1.0) = 0.5;
uniform vec3 vignette_color : source_color = vec3(0.0, 0.0, 0.0);
uniform int pixelation_steps : hint_range(2, 96) = 48;
uniform bool hard_edges = false;

void fragment() {
    vec2 center = vec2(0.5, 0.5);
    vec2 uv = UV - center;
    
    // Calculate distance from center
    float distance = length(uv);
    
    // Pixelate the distance by quantizing it into discrete steps
    float pixelated_distance = floor(distance * float(pixelation_steps)) / float(pixelation_steps);
    
    // Create vignette mask with pixelated effect
    float vignette;
    
    if (hard_edges) {
        // Use step function for very sharp, retro pixelated edges
        vignette = step(pixelated_distance, vignette_radius);
    } else {
        // Use smoothstep on the pixelated distance for softer but still quantized transitions
        vignette = 1.0 - smoothstep(vignette_radius - 0.1, vignette_radius + 0.1, pixelated_distance);
    }
    
    vignette = 1.0 - (1.0 - vignette) * vignette_intensity;
    
    // Apply vignette
    COLOR = vec4(vignette_color, 1.0 - vignette);
}