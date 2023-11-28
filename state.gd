extends Node

var current_score = 0
var game_over = false
var body_count = 4
var current_direction = Direction.DOWN

var apple_position
var head_position
var body_positions = []


const GRID_SIZE = 30
const GRID_PADDING = 1
var window_size : Vector2 = Vector2(500, 500)
var rectangle_size : Vector2 = window_size / GRID_SIZE

