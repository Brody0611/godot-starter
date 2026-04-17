extends Node2D

func _ready() -> void:
	var key = get_node("key_item")
	if key == null:
		return
	key.connect("collected", on_key_collected)

func on_key_collected():
	print("Yes")
