extends Node2D
var NODE_NAME = "bullet"

@export var speed:float = 10
@export var heatGening:float = 1
@export var dmg:int = 50

var newPos
var hit = false

func init(pos) :
	position = pos
	
func _ready():
	look_at(get_viewport().get_mouse_position())
	newPos = Vector2(cos(rotation),sin(rotation))*speed
	$Ani.play("default")
	$bloomBox.monitoring = false
	$Polygon2D2.visible = false

func _physics_process(delta):
	if not hit:
		position += newPos
	
func bloom():
	if hit :return
	hit = true
	$bloomOut.start()
	$Polygon2D.visible = false
	$bloomBox.monitoring = true
	$Polygon2D2.visible = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_bloom_timeout():
	bloom()

func _on_bloom_out_timeout():
	queue_free()

func _on_bloom_box_body_entered(body):
	body.on_getAttacked(dmg)

func _on_hit_box_body_entered(body):
	bloom()
	
