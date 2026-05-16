shader_type canvas_item;

uniform sampler2D screen : hint_screen_texture, filter_nearest;
uniform float ratio : hint_range(0.0, 1.0);

void fragment() {
	vec4 I = texture(screen, SCREEN_UV);
	float ave = (I.r + I.g + I.b) / 3.0;
	COLOR = mix(I, vec4(ave, ave, ave, I.a), ratio);
}