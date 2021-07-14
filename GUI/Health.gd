extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var full_hearts = $HeartFull
onready var empty_hearts = $HeartEmpty

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if full_hearts != null:
		full_hearts.rect_size.x = hearts * 16
		
func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if empty_hearts != null:
		empty_hearts.rect_size.x = max_hearts * 16
		
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	print(max_hearts)
	#ignore-warning:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_hearts")
	#ignore-warning:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
