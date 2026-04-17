extends Area2D
signal collected
func _on_body_entered(body):
	if body.is_in_group("player"):
		collected.emit(collected)
		queue_free() # Remove the coin when the player touches it
