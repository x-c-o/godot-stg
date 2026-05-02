shader_type canvas_item;
render_mode blend_premul_alpha;

uniform sampler2D tex_game_bg;
uniform sampler2D tex_game_hl_ui;
uniform sampler2D tex_game_ui;
uniform sampler2D tex_game;
uniform sampler2D tex_mask;

uniform vec2 camera_offset;

vec4 blend(vec4 bg, vec4 fg) {
    vec4 result;
	result.a = fg.a + bg.a * (1.0 - fg.a);
    result.rgb = fg.rgb + bg.rgb * (1.0 - fg.a);
    return result;
}

void fragment() {
	vec2 uv_shake = UV + camera_offset * SCREEN_PIXEL_SIZE;
	vec4 col_mask = texture(tex_mask, UV);
	vec4 col_game_bg = texture(tex_game_bg, uv_shake);
	vec4 col_game_hl_ui = texture(tex_game_hl_ui, UV);
	vec4 col_game_ui = texture(tex_game_ui, UV);
	vec4 col_game = texture(tex_game, uv_shake);
	vec4 col_final = vec4(0.0);
	col_final = blend(col_final, step(0.5, col_mask.a) * col_game_bg);
	col_final = blend(col_final, col_game_hl_ui);
	col_final = blend(col_final, step(0.5, col_mask.a) * col_game);
	col_final = blend(col_final, step(0.5, col_mask.a) * col_game_ui);
	COLOR = col_final;
}