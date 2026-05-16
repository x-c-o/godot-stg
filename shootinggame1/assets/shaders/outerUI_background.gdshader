shader_type canvas_item;

uniform sampler2D mask;

void fragment(){
	COLOR = texture(TEXTURE, UV);
	COLOR.a *= step(texture(mask, UV).r, 0.5);
}