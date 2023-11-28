extends Control

@export var is_debugging = false
var tick_in_seconds = 0.15
var time_passed = 0


func _ready():
	if(is_debugging):
		$PlayerPosition.show()
		
	init_game()


func init_game():
	State.game_over = false
	time_passed = 0
	$MapCanvas.reset()
	$SnakeController.reset()


func _process(delta):
	if(State.game_over):
		return
	
	time_passed += delta
	if(time_passed > tick_in_seconds):
		time_passed = 0
		
		# Debug Line
		$PlayerPosition.text = str(State.head_position)
	
		$SnakeController.tick()
		
		handle_food_collision()
		handle_other_collisions()
		
	
	$MapCanvas.draw()

func handle_food_collision():
	var has_found_food = State.head_position.is_equal_approx(State.apple_position)
	if(has_found_food):
		$MapCanvas.generate_new_apple()
		State.body_count += 1
		
		increase_score()
		
		# Increase game speed
		tick_in_seconds = tick_in_seconds * 0.9 

func handle_other_collisions():
	if(has_collided()):
		State.game_over = true
		$Fade.show()
		$GameOverScreen.show()
		
		
func has_collided():
	var has_collided_with_body = State.head_position in State.body_positions
	var has_hit_horizontal_side = State.head_position.x <= 0 or State.head_position.x >= Property.window_size.x - (Property.block_size.x + 1)
	var has_hit_vertical_side = State.head_position.y <= 0 or State.head_position.y >= Property.window_size.y - (Property.block_size.y + 1)
	return has_collided_with_body or has_hit_horizontal_side or has_hit_vertical_side

func increase_score():
	State.current_score += 100
	$ScoreValue.text = str(State.current_score)
	
