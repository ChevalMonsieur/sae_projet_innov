extends AIController2D
class_name AIControllerCustom

var move_action : Vector2 = Vector2.ZERO
var shoot_direction_action : Vector2 = Vector2.ZERO

func get_obs() -> Dictionary:
	var ai_pos = GameManager.instance.boss.position
	var player_pos = GameManager.instance.player.position
	var obs = [ai_pos.x, ai_pos.y, player_pos.x, player_pos.y]

	return {"obs":obs}

func get_reward() -> float:	
	return reward
	
func get_action_space() -> Dictionary:
	return {
		"move_action" : {
			"size": 2,
			"action_type": "continuous"
		},		
		"shoot_direction_action" : {
			"size": 2,
			"action_type": "continuous"
		},
	}
	
func set_action(action) -> void:
	move_action = Vector2(floor(action["move_action"][0]), floor(action["move_action"][1]))
	shoot_direction_action = Vector2(action["shoot_direction_action"][0], action["shoot_direction_action"][1]).normalized()
