shader_type canvas_item;

uniform float brightness = 0.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	COLOR = vec4((color.rgb + brightness), color.a);
}