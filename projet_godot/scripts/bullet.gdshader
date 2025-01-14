shader_type canvas_item;

uniform vec3 color;

void fragment() {
	COLOR = vec4(color, 1);
}
