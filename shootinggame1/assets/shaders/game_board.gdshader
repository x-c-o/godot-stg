shader_type canvas_item;
render_mode blend_premul_alpha;

uniform sampler2D gameBG_texture;
uniform sampler2D gameText_texture;
uniform sampler2D game_texture;
uniform sampler2D mask_texture;

uniform vec2 camera_offset;

vec4 blend(vec4 bg, vec4 fg) {
    vec4 result;
	result.a = fg.a + bg.a * (1.0 - fg.a);
    result.rgb = fg.rgb + bg.rgb * (1.0 - fg.a);
    return result;
}

void fragment() {
	vec4 mask_color = texture(mask_texture, UV);
	vec4 gameBG_color = texture(gameBG_texture, UV + camera_offset * SCREEN_PIXEL_SIZE);
	vec4 gameText_color = texture(gameText_texture, UV + camera_offset * SCREEN_PIXEL_SIZE);
	vec4 game_color = texture(game_texture, UV + camera_offset * SCREEN_PIXEL_SIZE);
	vec4 final_color = vec4(0.0);
	final_color = blend(final_color, step(0.5, mask_color.a) * gameBG_color);
	final_color = blend(final_color, gameText_color);
	final_color = blend(final_color, step(0.5, mask_color.a) * game_color);
	COLOR = final_color;
}