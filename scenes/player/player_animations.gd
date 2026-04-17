extends Node2D

@export var animation_tree: AnimationTree
@onready var player: Player = get_owner()

var facing = 0

func _physics_process(delta: float) -> void:
	var state = player.current_state
	
	if player.velocity.x != 0:
		facing = player.velocity.x
	
	animation_tree.set("parameters/conditions/Falling", state == Player.PlayerStates.FALLING)
	animation_tree.set("parameters/conditions/Idle", state == Player.PlayerStates.IDLE)
	animation_tree.set("parameters/conditions/Jumping", state == Player.PlayerStates.JUMPING)
	animation_tree.set("parameters/conditions/Walking", state == Player.PlayerStates.WALKING)
	
	animation_tree.set("parameters/Falling/blend_position", facing)
	animation_tree.set("parameters/Idle/blend_position", facing)
	animation_tree.set("parameters/Jumping/blend_position", facing)
	animation_tree.set("parameters/Walking/blend_position", facing)
