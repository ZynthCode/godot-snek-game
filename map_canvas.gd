extends Control

@onready var window_size : Vector2 = self.get_rect().size
@onready var block_size : Vector2 = window_size / Property.grid_size

func draw():
	queue_redraw()

func reset():
	generate_new_apple()

func generate_new_apple():
	State.apple_position = get_random_pos()

func _draw():
	draw_world()
	draw_entities()

func draw_world():
	var grid_size = Property.grid_size
	
	# Draw World
	for x in range(0, Property.grid_size):
		for y in range(0, Property.grid_size):
			draw_rect(Rect2(x * block_size.x, y * block_size.y, block_size.x, block_size.y), Color.RED)

func draw_entities():
	draw_rect(Rect2(State.apple_position, block_size), Color.GREEN)
	draw_rect(Rect2(State.head_position, block_size), Color.BLUE)
	
	for body in State.body_positions:
		draw_rect(Rect2(body, block_size), Color.BLACK)


func get_random_pos() -> Vector2:
	randomize()
	const SPAWN_PADDING = 3
	var random_pos = Vector2(randi_range(SPAWN_PADDING, Property.grid_size - SPAWN_PADDING), randi_range(SPAWN_PADDING, Property.grid_size - SPAWN_PADDING))
	return random_pos * block_size
