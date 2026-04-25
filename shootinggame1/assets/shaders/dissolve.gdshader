shader_type canvas_item;
 
uniform sampler2D noise;
uniform float ratio : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D screen : hint_screen_texture, filter_nearest;
 
void fragment() {
	COLOR = texture(TEXTURE, UV) * mix(vec4(0.0), texture(TEXTURE, UV), smoothstep(
		ratio, ratio + 0.1, texture(noise, UV).r
	));
}