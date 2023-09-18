extends Node2D

@export var repairCooler:float = 1

func init(pos):
	position = pos

func _ready():
	add_to_group("interact")
	add_to_group("radar")
	add_to_group("system")
	get_tree().call_group("radar","on_keyItemPos",position)

func _process(delta):
	pass

func _on_hit_box_body_entered(body):
	get_tree().call_group("interact","on_getKeyItem",repairCooler)
	queue_free()

func on_callPos():
	get_tree().call_group("radar","on_keyItemPos",position)
