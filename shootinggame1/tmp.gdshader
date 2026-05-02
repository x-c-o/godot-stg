shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float ratio : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec2 uv = (SCREEN_UV - REGION_RECT.xy) / REGION_RECT.zw;uv.x = min(uv.x, ratio);
	vec4 c = texture(screen_texture, uv);
	if (c.a > 0.0001) {
		c.rgb /= c.a;
	}
	COLOR *= c;
	//COLOR = vec4(uv, 0.0, 1.0);
}