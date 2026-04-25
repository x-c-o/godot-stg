shader_type canvas_item;

uniform sampler2D mask_texture;

uniform float thickness : hint_range(0.0, 16.0, 0.1) = 2;
uniform vec4 outline_color : source_color = vec4(0, 1, 1, 1);

void fragment(){
    float sx = thickness * 1.0 / float(textureSize(mask_texture,0).x);
	float sy = thickness * 1.0 / float(textureSize(mask_texture,0).y);
    vec4 sprite_color = texture(mask_texture,UV);
    float alpha = - 8.0 * sprite_color.a;
    alpha += texture(mask_texture, UV + vec2(0.0,-sy)).a;
    alpha += texture(mask_texture, UV + vec2(sx,-sy)).a;
    alpha += texture(mask_texture, UV + vec2(sx,0.0)).a;
    alpha += texture(mask_texture, UV + vec2(sx,sy)).a;
    alpha += texture(mask_texture, UV + vec2(0.0,sy)).a;
    alpha += texture(mask_texture, UV + vec2(-sx,sy)).a;
    alpha += texture(mask_texture, UV + vec2(-sx,0.0)).a;
    alpha += texture(mask_texture, UV + vec2(-sx,-sy)).a;
    COLOR = vec4(outline_color.rgb, clamp(abs(alpha) + sprite_color.a, 0.0, 1.0));
}