extends Camera2D

onready var upperLeft = $Limits/UpperLeft
onready var bottomRight = $Limits/BottomRight

func _ready():
	limit_left = upperLeft.position.x
	limit_top = upperLeft.position.y
	limit_right = bottomRight.position.x
	limit_bottom = bottomRight.position.y
