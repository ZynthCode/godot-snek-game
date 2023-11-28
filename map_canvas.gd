extends Control

func _process(delta):
	queue_redraw()

func is_inside_map(x,y) -> bool:
	return (x != State.GRID_SIZE-1 and x != 0) and (y != State.GRID_SIZE-1 and y != 0)

func _draw():
	# Draw World
	for x in range(0, State.GRID_SIZE):
		for y in range(0, State.GRID_SIZE):
			if(is_inside_map(x,y)):
				draw_rect(Rect2(x * State.rectangle_size.x, y * State.rectangle_size.y, State.rectangle_size.x - State.GRID_PADDING, State.rectangle_size.y - State.GRID_PADDING), Color.RED)
		pass
	pass
	
	# Draw apple
	draw_rect(Rect2(State.apple_position, State.rectangle_size), Color.GREEN)
	
	# Draw Player
	draw_rect(Rect2(State.head_position, State.rectangle_size), Color.BLUE)
	
	# Draw Body
	for body in State.body_positions:
		draw_rect(Rect2(body, State.rectangle_size), Color.BLACK)
