extends CharacterBody2D

@export var speed: float = 3.0
@export var max_speed: float = 10.0
@export var score_label: RichTextLabel
@export var start_text: RichTextLabel
@export var lives_text: RichTextLabel

var forward = Vector2(1,1).normalized()
const PADDLE_WIDTH: float = 100.0
var current_score: int = 0
var is_running: bool = false
var ballState: int = 0
var lives: int = 3

func _ready() -> void:
	modulate = Color(0,1,1)

func _physics_process(_delta_: float) -> void:
	if (not is_running):
		if (Input.is_action_just_pressed("click_window")):
			is_running = true
			start_text.visible = false
			visible = true
			if(lives == 0):
				get_tree().reload_current_scene() 
			

		return
	
	var collision: KinematicCollision2D = move_and_collide(forward * speed)
	if (collision):
		forward = forward.bounce(collision.get_normal())
		speed = clamp(speed + 0.5, 1, max_speed)
		
		if (collision.get_collider().is_in_group("Bricks")):
			collision.get_collider().queue_free()
			current_score += 10
			score_label.text = "SCORE: " + str(current_score)
			if (ballState == 0):
				modulate = Color(1,1,0)
				set_collision_mask_value(2,0)
				set_collision_mask_value(3,1)
				ballState += 1
			elif (ballState == 1):
				modulate = Color(1,0,1)
				set_collision_mask_value(3,0)
				set_collision_mask_value(4,1)
				ballState += 1
			elif (ballState == 2):
				modulate = Color(0,1,1)
				set_collision_mask_value(4,0)
				set_collision_mask_value(2,1)
				ballState = 0
		
		# Paddle bounce should be based on ball position
		if (collision.get_collider().is_in_group("Paddle")):
			var paddle_x = collision.get_collider().position.x - PADDLE_WIDTH / 2
			var pos_on_paddle = (position.x - paddle_x) / PADDLE_WIDTH
			#print("Hit the paddle!" + str(pos_on_paddle))
			var bounce_angle = lerp(-PI * 0.8, -PI * 0.2, pos_on_paddle)
			forward = Vector2.from_angle(bounce_angle)
			
		#Handle game over conditions
		if (collision.get_collider().is_in_group("GameOver")):
			if(lives == 0):
				is_running = false
				start_text.visible = true
				start_text.text = "GAME OVER"
			else:
				lives -= 1
				lives_text.text = "LIVES: " + str(lives)
				if(speed > 5):
					speed -= 2
				
