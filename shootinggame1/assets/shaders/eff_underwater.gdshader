shader_type canvas_item;

uniform sampler2D screen : hint_screen_texture, filter_nearest;

uniform float speed : hint_range(0.0, 4.0) = 1.0;
uniform float wave : hint_range(0.0, 100.0) = 20.0;
uniform float warp : hint_range(0.0, 20.0) = 5.0;

void fragment() {
	vec2 uv = UV;
	float tim = TIME * speed;
	vec2 s = uv * wave + tim;
	uv.x += sin(s.x - s.y) * warp * 0.001 * sin(s.y);
	uv.y += cos(s.x + s.y) * warp * 0.001 * cos(s.y);
	COLOR = texture(screen, uv);
}