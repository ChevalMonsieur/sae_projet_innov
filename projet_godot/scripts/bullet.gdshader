shader_type canvas_item;

uniform vec2 node_position;
uniform vec2 definition;

void fragment() {
	vec2 pos = SCREEN_UV * definition;
	float normalized_dist = distance(pos, node_position) / 500.;
	COLOR = vec4(1, 1, normalized_dist, 1);
}
