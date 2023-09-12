extends Node2D
var NODE_NAME = "bullet"

@export var speed:float = 10
@export var heatGening:float = 1
@export var dmg:int = 50

var newPos

func init(pos) :
	position = pos
	
func _ready():
	look_at(get_viewport().get_mouse_position())
	newPos = Vector2(cos(rotation),sin(rotation))*speed

func _process(delta):
	position += newPos

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_hit_box_body_entered(body):
	body.on_getAttacked(dmg)
