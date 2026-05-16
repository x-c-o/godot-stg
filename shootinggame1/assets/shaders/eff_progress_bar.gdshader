shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform sampler2D noise_c : repeat_enable;
uniform sampler2D gradient_b;
uniform sampler2D gradient_f;
uniform float ratio : hint_range(0.0, 1.0);

void fragment() {
	float v_noise = texture(noise, UV + vec2(-0.05 * TIME, 0.0)).r;
	float v_noise_c = texture(noise_c, UV + vec2(-0.03 * TIME, 0.0)).r;
	vec4 col = mix(texture(gradient_b, UV), texture(gradient_f, UV), smoothstep(0.2, 0.5, v_noise * v_noise_c));
	float r = mix(0.0, 1.1, ratio);
	float th = mix(-0.5, 1.0, smoothstep(r, r - 0.2, UV.x));
	vec4 col_inner = col * smoothstep(v_noise - 0.5, v_noise, th);
	// 下面两行需要修改
	float th2 = mix(-0.5, 1.0, smoothstep(r + 0.05, r - 0.15, UV.x));
	vec4 col_border = vec4(0.0, 0.0, 0.0, 1.0) * smoothstep(v_noise - 0.5, v_noise, th2);
	COLOR = col_inner + col_border;
}