extends Node2D
var NODE_NAME = "bullet"

@export var speed:float = 10
@export var heatGening:float = 1
@export var dmg:int = 40
@export var spread:int = 7

var newPos
var hit = false

func init(pos) :
	position = pos
	
func _ready():
	add_to_group("audio")
	$Ani.play("default")
	get_tree().call_group("audio","on_play","shootNormal")
	look_at(get_global_mouse_position())
	rotation_degrees += randi_range(-spread,spread)
	newPos = Vector2(cos(rotation),sin(rotation))*speed

func _physics_process(delta):
	if not hit :position += newPos

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_hit_box_body_entered(body):
	hit = true
	body.on_getAttacked(dmg)
	$Ani.play("Hit")
	await get_tree().create_timer(0.3).timeout
	queue_free()
