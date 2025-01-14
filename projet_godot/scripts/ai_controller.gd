extends AIController2D
class_name AIControllerCustom

var move_action : Vector2 = Vector2.ZERO
var shoot_direction_action : Vector2 = Vector2.ZERO

func get_obs() -> Dictionary:
	var enemy_direction: int = 0
	var enemy_distance: int = 0
	var pos_in_arena: Vector2 = get_parent().position / 800
	
	if get_parent().name == "boss":
		enemy_direction = rad_to_deg((get_parent().get_parent().find_child("boss2").position - get_parent().position).angle())
	else:
		enemy_direction = rad_to_deg((get_parent().get_parent().find_child("boss").position - get_parent().position).angle())

	enemy_distance = (get_parent().get_parent().find_child("boss2").position - get_parent().position).length()

	if Time.get_ticks_msec() % 300 == 0:
		#print('distance to enemy: ' + str(enemy_distance))
		print('enemy relative direction: ' + str(enemy_direction))
		print('reward: ' + str(reward))
		#print('current: ' + str(pos_in_arena))
		print('')
		
	var obs = [enemy_direction]
	return {"obs":obs}

func get_reward() -> float:	
	return reward
	
func get_action_space() -> Dictionary:
	return {
		#"move_action" : {
			#"size": 2,
			#"action_type": "continuous"
		#},		
		"shoot_direction_action" : {
			"size": 360,
			"action_type": "discrete"
		},
	}
	
func set_action(action) -> void:
	#move_action = Vector2(floor(action["move_action"][0]), floor(action["move_action"][1]))
	move_action = Vector2.ZERO
	shoot_direction_action = Vector2(1, 0).rotated(rad_to_deg(action["shoot_direction_action"]))
