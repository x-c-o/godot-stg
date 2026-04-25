shader_type canvas_item;

uniform float X : hint_range(-1.0, 1.0, 0.01) = .0;
uniform float Y : hint_range(-1.0, 1.0, 0.01) = .0;

void vertex(){
	float vertPosY = (-VERTEX.y * X) + VERTEX.x;
	VERTEX.x = vertPosY;
	float vertPosX = (-VERTEX.x * Y) + VERTEX.y;
	VERTEX.y = vertPosX;
}