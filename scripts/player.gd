extends CharacterBody2D
var NODE_TYPE = "player"

@export var speed = 300
var liquid = 0
var canInteract = ""

func _ready():
	get_tree().call_group("heat","on_liquidInPlayer",liquid)
	$animate.play("idle")
	add_to_group("heat")
	add_to_group("interact")

func _physics_process(delta):
	var v = Input.get_axis("ui_left","ui_right")
	var h = Input.get_axis("ui_up","ui_down")
	var dir = Vector2(v,h)
	
	if dir.x : 
		$animate.flip_h = !(dir.x+1)
	
	if dir.y == 1 : $animate.play("running")
	else : $animate.play("idle")
	
	velocity = dir*speed

	move_and_slide()

func on_liquidPickup(liq):
	liquid += liq
	get_tree().call_group("heat","on_liquidInPlayer",liquid)

func _input(event):
	if event.is_action_pressed("cooler") and canInteract == "ship":
		get_tree().call_group("heat","on_cooling",liquid)
	
	if event.is_action_pressed("getInOutShip") and canInteract == "ship":
		get_tree().call_group("interact","on_getInShip")
		
func on_overLiquid(liq):
	liquid = liq
	get_tree().call_group("heat","on_liquidInPlayer",liquid)
