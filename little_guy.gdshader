shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
	

void fragment() {
	
	float pixel_size = 2.0;
	
	vec2 chunky_fragcoord = floor(FRAGCOORD.xy / pixel_size) * pixel_size;
	vec2 chunky_uv = chunky_fragcoord * SCREEN_PIXEL_SIZE;
	
	vec4 raw_colour = texture(screen_texture, chunky_uv);
	float brightness = (raw_colour.r + raw_colour.g + raw_colour.b) / 3.0;
	
	brightness = brightness * 3.0;
	
	int x = int(chunky_fragcoord.x / pixel_size) % 4;
	int y = int(chunky_fragcoord.y / pixel_size) % 4;
	
	float m[16] = float[](
		0.0625, 0.5625, 0.1875, 0.6875,
        0.8125, 0.3125, 0.9375, 0.4375,
        0.2500, 0.7500, 0.1250, 0.6250,
        1.0000, 0.5000, 0.8750, 0.3750
	);
	
	float threshold = m[y * 4 + x];
	
	if (brightness > threshold) {
		COLOR = vec4(0.694, 0.593, 0.792, 1.0);
	} else {
		COLOR = vec4 (0.13, 0.164, 0.358, 1.0);
	}
}
