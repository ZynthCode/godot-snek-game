extends Control

var tick_in_seconds = 0.15
var time_passed = 0

var black_color_rect
var game_over_label
var score_label

func _ready():
	setup_nodes()
	init_game()

func setup_nodes():
		var full_window_size = get_viewport().get_visible_rect().size
		
		black_color_rect = ColorRect.new()
		black_color_rect.set_color(Color.BLACK)
		black_color_rect.set_size(full_window_size)
		black_color_rect.hide()
		add_child(black_color_rect)
		
		score_label = Label.new()
		score_label.set_size(full_window_size + Vector2(0, 100))
		score_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
		score_label.set_vertical_alignment(VERTICAL_ALIGNMENT_CENTER)
		score_label.hide()
		add_child(score_label)
		
		game_over_label = Label.new()
		game_over_label.set_size(full_window_size)
		game_over_label.set_text("Game Over")
		game_over_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
		game_over_label.set_vertical_alignment(VERTICAL_ALIGNMENT_CENTER)
		game_over_label.hide()
		add_child(game_over_label)

func _input(event: InputEvent):
	if(State.game_over):
		if(event.is_action_pressed("ui_accept")):
			init_game()

func init_game():
	State.game_over = false
	time_passed = 0
	State.current_score = 0
	$ScoreValue.text = "0"
	$MapCanvas.reset()
	$SnakeController.reset()
	black_color_rect.hide()
	game_over_label.hide()
	score_label.hide()


func _process(delta):
	if(State.game_over):
		return
	
	time_passed += delta
	if(time_passed > tick_in_seconds):
		time_passed = 0
		$SnakeController.process_movement()
		handle_collisions()
	
	$MapCanvas.draw()

func handle_collisions():
	if($SnakeController.has_collided()):
		State.game_over = true
		black_color_rect.show()
		game_over_label.show()
		score_label.set_text(str(State.current_score))
		score_label.show()

	if($SnakeController.has_found_food()):
		$MapCanvas.generate_new_apple()
		$SnakeController.grow()
		increase_score()
		increase_speed()


func increase_score():
	State.current_score += 100
	$ScoreValue.text = str(State.current_score)

func increase_speed():
	tick_in_seconds = tick_in_seconds * 0.9 
