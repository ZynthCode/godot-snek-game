extends Control

const GRID_PADDING = 1

func draw():
	queue_redraw()

func reset():
	generate_new_apple()

func generate_new_apple():
	State.apple_position = get_random_pos()

func _draw():
	var block_size = Property.block_size
	var grid_size = Property.grid_size
	# Draw World
	for x in range(0, Property.grid_size):
		for y in range(0, Property.grid_size):
			if(is_inside_map(x,y)):
				draw_rect(Rect2(x * block_size.x, y * block_size.y, block_size.x - grid_size, block_size.y - grid_size), Color.RED)
	
	# Draw apple
	draw_rect(Rect2(State.apple_position, Property.block_size), Color.GREEN)
	
	# Draw Head
	draw_rect(Rect2(State.head_position, Property.block_size), Color.BLUE)
	
	# Draw Body
	for body in State.body_positions:
		draw_rect(Rect2(body, Property.block_size), Color.BLACK)

func is_inside_map(x,y) -> bool:
	return (x != Property.grid_size-1 and x != 0) and (y != Property.grid_size-1 and y != 0)

func get_random_pos() -> Vector2:
	randomize()
	const SPAWN_PADDING = 3
	var random_pos = Vector2(randi_range(SPAWN_PADDING, Property.grid_size - SPAWN_PADDING), randi_range(SPAWN_PADDING, Property.grid_size - SPAWN_PADDING))
	return random_pos * Property.block_size
