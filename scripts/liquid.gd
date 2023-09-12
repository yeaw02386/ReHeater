extends Node2D

var liquid

func init(liq,pos):
	liquid = liq
	position = pos

func _ready():
	$Ani.play("floating")

func _process(delta):
	pass


func _on_hit_box_body_entered(body):
	print("pick")
	body.on_liquidPickup(liquid)
	queue_free()
