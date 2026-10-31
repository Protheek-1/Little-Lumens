shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void fragment() {
	// Base game resolution
	vec2 base_res = vec2(256.0, 256.0);
	
	// Set your desired chunky pixel size (2.0 makes pixels twice as big)
	float pixel_size = 2.0;
	
	// Create a virtual low-res grid (128x128)
	vec2 chunky_res = base_res / pixel_size;
	
	// Snap the UV precisely to our chunky grid coordinates
	vec2 chunky_uv = floor(UV * chunky_res) / chunky_res;
	
	// Sample the screen using our stabilized chunky coordinates
	vec4 raw_colour = texture(screen_texture, chunky_uv);
	float brightness = (raw_colour.r + raw_colour.g + raw_colour.b) / 3.0;
	
	brightness = brightness * 3.0;
	
	// Calculate matrix indexes relative to the new pixel block layout
	int x = int(chunky_uv.x * chunky_res.x) % 4;
	int y = int(chunky_uv.y * chunky_res.y) % 4;
	
	float m[16] = float[](
		0.0625, 0.5625, 0.1875, 0.6875,
		0.8125, 0.3125, 0.9375, 0.4375,
		0.2500, 0.7500, 0.1250, 0.6250,
		1.0000, 0.5000, 0.8750, 0.3750
	);
	
	float threshold = m[y * 4 + x];
	
	if (brightness > threshold) {
		COLOR = vec4(0.764, 0.583, 0.259, 1.0);
	} else {
		COLOR = vec4(0.232, 0.155, 0.032, 1.0);
	}
}
