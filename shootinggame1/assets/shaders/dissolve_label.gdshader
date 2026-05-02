shader_type canvas_item;
 
uniform sampler2D noise;
uniform float ratio : hint_range(0.0, 1.0) = 0.0;
 
void fragment() {
	COLOR *= texture(TEXTURE, UV);
	COLOR.a *= smoothstep(ratio, ratio + 0.1, texture(noise, UV).r);
}