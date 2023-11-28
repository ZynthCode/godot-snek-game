extends Control

var is_debugging = false
const GRID_SIZE = 30
const padding = 1

@onready var window_size : Vector2 = Vector2(500, 500)
@onready var rectangle_size : Vector2 = window_size / GRID_SIZE

var tick_in_seconds = 0.25
var time_passed = 0

@onready var apple_position = get_random_pos()

var current_score = 0
var game_over = false
const DIRECTION = {
	ZERO = Vector2(0, 0), 
	UP = Vector2(0, -1), 
	DOWN = Vector2(0, 1), 
	RIGHT = Vector2(1, 0), 
	LEFT = Vector2(-1, 0)
	}

var body_count = 4

@onready var head_position = get_random_pos()
@onready var body_positions = []

var current_direction = DIRECTION.DOWN
var previous_direction = current_direction

func get_random_pos() -> Vector2:
	randomize()
	const SPAWN_PADDING = 3
	var random_pos = Vector2(randi_range(SPAWN_PADDING, GRID_SIZE - SPAWN_PADDING), randi_range(SPAWN_PADDING, GRID_SIZE - SPAWN_PADDING))
	return random_pos * rectangle_size

func _ready():
	if(is_debugging):
		$PlayerPosition.show()

func _input(event : InputEvent):
	if(event.is_action_pressed("move_up") and not previous_direction == DIRECTION.DOWN):
		current_direction = DIRECTION.UP
	if(event.is_action_pressed("move_down") and not previous_direction == DIRECTION.UP):
		current_direction = DIRECTION.DOWN
	if(event.is_action_pressed("move_left") and not previous_direction == DIRECTION.RIGHT):
		current_direction = DIRECTION.LEFT
	if(event.is_action_pressed("move_right") and not previous_direction == DIRECTION.LEFT):
		current_direction = DIRECTION.RIGHT

func _process(delta):
	
	if(game_over):
		return
	
	time_passed += delta
	if(time_passed > tick_in_seconds):
		time_passed = 0
		
		# Debug Line
		$PlayerPosition.text = str(head_position)
		
		move_player()
		
		# If snek hit food
		if(head_position.is_equal_approx(apple_position)):
			# Eat
			apple_position = get_random_pos()
			body_count += 1
			
			# Update score
			current_score += 100
			$ScoreValue.text = str(current_score)
			
			# Increase game speed
			tick_in_seconds = tick_in_seconds * 0.9 
			pass
	
		if(has_collided()):
			$Fade.show()
			$GameOverScreen.show()
			game_over = true
			
		previous_direction = current_direction
	
	queue_redraw() 
	pass

func move_player():
	var previous_pos = head_position
	head_position += current_direction * rectangle_size
		
	body_positions.push_front(previous_pos)
	if(body_positions.size() > body_count):
		body_positions.pop_back()

func has_collided():
	var has_collided_with_body = head_position in body_positions
	var has_hit_horizontal_side = head_position.x <= 0 or head_position.x >= window_size.x - (rectangle_size.x + 1)
	var has_hit_vertical_side = head_position.y <= 0 or head_position.y >= window_size.y - (rectangle_size.y + 1)
	return has_collided_with_body or has_hit_horizontal_side or has_hit_vertical_side

func is_inside_map(x,y) -> bool:
	return (x != GRID_SIZE-1 and x != 0) and (y != GRID_SIZE-1 and y != 0)

func _draw():
	# Draw World
	for x in range(0, GRID_SIZE):
		for y in range(0, GRID_SIZE):
			if(is_inside_map(x,y)):
				draw_rect(Rect2(x * rectangle_size.x, y * rectangle_size.y, rectangle_size.x - padding, rectangle_size.y - padding), Color.RED)
		pass
	pass
	
	# Draw apple
	draw_rect(Rect2(apple_position, rectangle_size), Color.GREEN)
	
	# Draw Player
	draw_rect(Rect2(head_position, rectangle_size), Color.BLUE)
	
	# Draw Body
	for body in body_positions:
		draw_rect(Rect2(body, rectangle_size), Color.BLACK)
