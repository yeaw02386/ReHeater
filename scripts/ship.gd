extends Node2D
@export var player:PackedScene

var MAX_HEAT = 1000
var NODE_TYPE = "ship"
var heat = 400
var coolerDMG = 1
var playerIns
var playerInShip = false
@onready var camera = get_node("camera")

func playerGetOut():
	$Ani.play("OutShip")
	$Stat/StatAni.play("StatOutit")
	await get_tree().create_timer(0.3).timeout
	$gun.playerInShip = false
	playerInShip = false
	playerIns.global_position = $playerPoint.global_position
	remove_child(camera)
	playerIns.add_child(camera)
	
	get_parent().add_child(playerIns)

func _ready():
	$Ani.play("Empty")
	playerIns = player.instantiate()
	add_to_group("heat")
	add_to_group("enemyAttack")
	add_to_group("interact")
	add_to_group("gun")
	add_to_group("camera")
	
	on_heating(0)
	on_coolerDamage(0)
	
	playerIns.global_position = $playerPoint.global_position
	get_parent().add_child(playerIns)
	#playerGetOut()

func _process(delta):
	if playerInShip :
		var mouse = get_viewport().get_mouse_position()-global_position
		get_tree().call_group("camera","on_mouseMove",mouse)
	
func on_heating(temp) :
	heat += temp*coolerDMG
	if heat >= MAX_HEAT :
		get_tree().call_group("heat","on_destroy")
		queue_free()
	get_tree().call_group("heat","on_heatUpdate",heat)

func on_cooling(temp) :
	get_tree().call_group("heat","on_heatUpdate",heat)
	if temp-heat >0 :
		heat = 0
		temp = temp-heat
	else : 
		heat -= temp
		temp = 0
	get_tree().call_group("heat","on_overLiquid",temp)
	
func on_coolerDamage(dmg) :
	coolerDMG += dmg
	get_tree().call_group("heat","on_coolerDMGUpdate",coolerDMG)
	if coolerDMG >= 1000:
		return
	$damageLayer.frame = int(abs(coolerDMG-1)/2)
	#print(abs(coolerDMG-1)/2)
	
func on_heatUpdate(h):
	$smokeParticle/particleLight.emitting = true
	if heat < 500:
		$smokeParticle/particleNormal.emitting = false
		$smokeParticle/particleHeavy.emitting = false
		return
	$smokeParticle/particleNormal.emitting = true
	if heat < 900:
		$smokeParticle/particleHeavy.emitting = false
		return
	$smokeParticle/particleHeavy.emitting = true
	
	
	
	
	

func _on_hitbox_body_entered(body):
	if body.NODE_TYPE == "enemy":
		body.canAttack = true

func _on_interact_body_entered(body):
	body.canInteract = "ship"

func _on_interact_body_exited(body):
	body.canInteract = ""
	
func on_getInShip():
	$Stat/StatAni.play("StatInit")
	$Ani.play("OnShip")
	playerIns.remove_child(camera)
	add_child(camera)
	get_parent().remove_child(playerIns)
	$gun.playerInShip = true
	$getInShipDelay.start()
	
	$getOut.visible = true
	$leftClick.visible = true
	$rightClick.visible = true
	await get_tree().create_timer(0.3).timeout
	$Stat/StatAni.play("StatHover")
	
func _input(event):
	if event.is_action_pressed("getInOutShip") and playerInShip: 
		$Ani.play("Empty")
		playerGetOut()

func _on_get_in_ship_delay_timeout():
	playerInShip = true
	
func on_playShoot():
	$Ani.play("Attack")
	await get_tree().create_timer(0.15).timeout
	$Ani.play("OnShip")
	
