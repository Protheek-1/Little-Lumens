shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void fragment() {
	float dist = distance(UV, vec2(0.5));
	if (dist > 0.5) {
		discard;
	}
	vec4 current_screen_pixel = texture(screen_texture, SCREEN_UV);
	vec3 inverted_rgb = vec3(1.0) - current_screen_pixel.rgb;
	
	float mask_alpha = 1.0;
	if (dist > 0.35) {
		mask_alpha = 1.0 - ((dist - 0.35) / (0.5 - 0.35));
	}
	
	vec3 final_rgb = mix(current_screen_pixel.rgb, inverted_rgb, mask_alpha);
	
	COLOR = vec4(final_rgb, 1.0);
}
