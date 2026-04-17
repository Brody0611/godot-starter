extends Area2D

signal collected

func _on_body_entered(body: Node) -> void:
	print("coin entered")
	if body.is_in_group("player"):
		collected.emit()
		%AnimationPlayer.play("Collect")
