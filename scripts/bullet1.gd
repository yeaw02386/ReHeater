extends Node2D

var speed
var newPos
func init(s,pos) :
	position = pos
	speed = s
	
func _ready():
	look_at(get_viewport().get_mouse_position())
	newPos = Vector2(cos(rotation),sin(rotation))*speed

func _process(delta):
	position += newPos


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
