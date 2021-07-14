extends Node2D

export (int) var wander_range = 32

onready var target_direction = Vector2.LEFT
onready var timer = $Timer

func _ready():
	randomize()
	pick_random_direction()
	
func get_time_left():
	return timer.time_left
	
func start_wander_timer(duration):
	timer.start(duration)
	
func _on_Timer_timeout():
	pick_random_direction()

func pick_random_direction():
	var directions = [Vector2.RIGHT, Vector2.LEFT]
	directions.shuffle()
	target_direction = directions.pop_front()
