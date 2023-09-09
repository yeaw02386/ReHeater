extends Node2D
@export var bullet:PackedScene
@export var bulletSpeed:int = 10
@export var heatGen:float = 1

func _ready():
	pass 

func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("attack") :
		shoot()

func shoot() :
	var ins = bullet.instantiate()
	var pos = $Polygon2D.position + get_parent().position + position
	ins.init(bulletSpeed,pos)
	get_parent().get_parent().add_child(ins)
	
	get_tree().call_group("heat","on_heating",heatGen)
	
