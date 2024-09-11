extends CharacterBody2D

var i: int = 2

func _physics_process(delta: float) -> void:
	position.x = get_viewport().get_mouse_position().x
	if Input.is_action_just_pressed("click_window"):
		if i == 0:
			modulate = Color(1,1,0)
			set_collision_layer_value(2,0)
			set_collision_layer_value(3,1)
			i += 1
		elif i == 1:
			modulate = Color(1,0,1)
			set_collision_layer_value(3,0)
			set_collision_layer_value(4,1)
			i += 1
		elif i == 2:
			modulate = Color(0,1,1)
			set_collision_layer_value(4,0)
			set_collision_layer_value(2,1)
			i = 0
