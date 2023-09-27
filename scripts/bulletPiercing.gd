extends Node2D
var NODE_NAME = "bullet"

@export var speed:float = 10
@export var heatGening:float = 1
@export var dmg:int = 50
@export var spread:int = 7

var newPos

func init(pos) :
	position = pos
	
func _ready():
	$Ani.play("default")
	look_at(get_global_mouse_position())
	rotation_degrees += randi_range(-spread,spread)
	newPos = Vector2(cos(rotation),sin(rotation))*speed

func _physics_process(delta):
	position += newPos

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_hit_box_body_entered(body):
	body.on_getAttacked(dmg)
