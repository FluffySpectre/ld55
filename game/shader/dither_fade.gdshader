shader_type canvas_item;

uniform float fade_amount : hint_range(0.0, 1.0) = 1.0;
uniform float dither_scale : hint_range(0.1, 4.0) = 1.0;
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    vec2 screen_pos = (SCREEN_UV / SCREEN_PIXEL_SIZE) * dither_scale;
    ivec2 pos = ivec2(screen_pos);
    
    // 4x4 Bayer dither pattern
    float dither = 0.0;
    int x = pos.x % 4;
    int y = pos.y % 4;
    
    if (x == 0 && y == 0) dither = 1.0/16.0;
    else if (x == 1 && y == 0) dither = 9.0/16.0;
    else if (x == 2 && y == 0) dither = 3.0/16.0;
    else if (x == 3 && y == 0) dither = 11.0/16.0;
    else if (x == 0 && y == 1) dither = 13.0/16.0;
    else if (x == 1 && y == 1) dither = 5.0/16.0;
    else if (x == 2 && y == 1) dither = 15.0/16.0;
    else if (x == 3 && y == 1) dither = 7.0/16.0;
    else if (x == 0 && y == 2) dither = 4.0/16.0;
    else if (x == 1 && y == 2) dither = 12.0/16.0;
    else if (x == 2 && y == 2) dither = 2.0/16.0;
    else if (x == 3 && y == 2) dither = 10.0/16.0;
    else if (x == 0 && y == 3) dither = 16.0/16.0;
    else if (x == 1 && y == 3) dither = 8.0/16.0;
    else if (x == 2 && y == 3) dither = 14.0/16.0;
    else dither = 6.0/16.0;
    
    if (fade_amount < dither) {
        discard;
    }
    
    COLOR = tex_color * color;
}