extends Node2D

@onready var player := $PlayerSpawn/Player
var unlock : bool = false

func _physics_process(delta: float) -> void:
#	if $Key_item._on_body_entered("player"):
#		unlock = true
	pass

func _ready() -> void:
	var lock_box = $Items
	if unlock:
		$Items.queue_free()
