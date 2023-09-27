extends CharacterBody2D
var NODE_TYPE = "player"

@export var speed = 300
var liquid = 0
var canInteract = ""
var keyDis = [0]
var prevTilePos = Vector2i(0,0)

func _ready():
	get_tree().call_group("heat","on_liquidInPlayer",liquid)
	$animate.play("idle")
	add_to_group("heat")
	add_to_group("interact")
	add_to_group("camera")
	add_to_group("radar")
	add_to_group("map")
	add_to_group("audio")

func _physics_process(delta):
	var v = Input.get_axis("ui_left","ui_right")
	var h = Input.get_axis("ui_up","ui_down")
	var dir = Vector2(v,h)
	
	if dir : 
		get_tree().call_group("map","on_entityUpdate",position,self)
	
	if dir.x : 
		$animate.flip_h = !(dir.x+1)
	
	if dir.y == 1 : $animate.play("running")
	elif dir.y == -1 : $animate.play("running back")
	elif dir.x == 1 : 
		$animate.play("running diag")
	elif dir.x == -1 :
		$animate.play("running diag")
		$animate.flip_h = !(dir.x+1)
		
	else : 
		if $animate.animation == "running":
			$animate.play("idle")
		elif $animate.animation == "running diag":
			$animate.play("idle diag")
		elif $animate.animation == ("running back"):
			$animate.play("idle back")
			
	
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
	
func on_destroy():
	queue_free()

func on_keyItemPos(pos):
	keyDis.append(position.distance_to(pos))

func _on_call_key_timeout():
	if keyDis.is_empty() : keyDis.append(100000)
	keyDis.sort()
	get_tree().call_group("radar","on_keyItemDistance",keyDis[0])
	keyDis.clear()
	get_tree().call_group("radar","on_callPos")

