extends CanvasLayer

onready var msgLabel = $MessageLabel

func _ready():
	msgLabel.hide()

func show_message(message):
	msgLabel.text = message
	msgLabel.show()
