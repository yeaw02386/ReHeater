extends Node2D

var liquid

func init(liq,pos):
	liquid = liq
	position = pos

func _ready():
	add_to_group("audio")
	$Ani.play("floating")

func _process(delta):
	pass

func _on_hit_box_body_entered(body):
	get_tree().call_group("audio","on_play","collectItem")
	body.on_liquidPickup(liquid)
	queue_free()
	
func on_destroyed():
	queue_free()
