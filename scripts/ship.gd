extends Node2D
@export var player:PackedScene

var isGameover = false
var MAX_HEAT = 1000
var NODE_TYPE = "ship"
var heat = 400
var coolerDMG = 1
var playerIns
var playerInShip = false
var isFocus = true
var keyItem = 0
var keyItemRequest

@onready var camera = get_node("camera")

func init(pos,req):
	position = pos
	keyItemRequest = req

func playerGetOut():
	animePlayerGetout()
	await get_tree().create_timer(0.3).timeout
	$gun.playerInShip = false
	playerInShip = false
	playerIns.global_position = $playerPoint.global_position
	
	remove_child(camera)
	playerIns.add_child(camera)
	
	get_parent().add_child(playerIns)
	get_tree().call_group("system","on_isPlayerGetout",true)

func _ready():
	$blowupAni.play("default")
	$Ani.play("Empty")
	playerIns = player.instantiate()
	add_to_group("heat")
	add_to_group("enemyAttack")
	add_to_group("interact")
	add_to_group("gun")
	add_to_group("system")
	add_to_group("camera")
	add_to_group("dayNight")
	
	on_heating(0)
	on_coolerDamage(0)
	
	playerIns.global_position = $playerPoint.global_position
	playerGetOut()

func _process(delta):
	if playerInShip :
		var mouse = get_global_mouse_position()-global_position
		get_tree().call_group("camera","on_mouseMove",mouse)
	
func on_heating(temp) :
	heat += temp*coolerDMG
	
	get_tree().call_group("heat","on_heatUpdate",heat)
	if heat >= MAX_HEAT and not isGameover:
		isGameover = true
		gameOver()

func gameOver():
	playerIns.remove_child(camera)
	add_child(camera)
	get_parent().remove_child(playerIns)
	$gun.playerInShip = false

	if playerInShip == true :
		$gun/gunAni.play("hoverDown")
		$gungateAni.play("close")
		$Stat/StatAni.play("StatOutit")


	$blowupAni.play("Shock")
	await get_tree().create_timer(1.5).timeout
	$blowupAni.play("Blow")
	await get_tree().create_timer(0.25).timeout
	$smokeParticle/particleExplosion.emitting = true
	$damageLayer.visible = false
	$Ani.play("Wrecked")
	await get_tree().create_timer(4).timeout
	$fadeAni.play("fadeOut")

	await get_tree().create_timer(2).timeout
	queue_free()
	get_tree().call_group("heat","on_destroy")

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
	
func on_coolerRepair(repair):
	coolerDMG = max(1,abs(repair-coolerDMG))
	get_tree().call_group("heat","on_coolerDMGUpdate",coolerDMG)

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
	get_tree().call_group("interact","on_showInteract","E to getin ship")
	get_tree().call_group("interact","on_showInteract","R to cooldown")
	body.canInteract = "ship"

func _on_interact_body_exited(body):
	body.canInteract = ""
	
func on_getInShip():
	if isGameover:
		return
	playerIns.remove_child(camera)
	add_child(camera)
	get_parent().remove_child(playerIns)
	$gun.playerInShip = true
	$getInShipDelay.start()
	animePlayerGetin()

	get_tree().call_group("system","on_isPlayerGetout",false)
	
	get_tree().call_group("interact","on_showInteract","E to getout ship")
	get_tree().call_group("interact","on_showInteract","Left Click to shoot")
	get_tree().call_group("interact","on_showInteract","Right Click to swap bullet")
	
func _input(event):
	if (event.is_action_pressed("getInOutShip") and 
									playerInShip and 
									$Ani.animation != "Wrecked"): 
		$Ani.play("Empty")
		playerGetOut()

func _on_get_in_ship_delay_timeout():
	playerInShip = true
	
func on_playShoot():
	if isGameover : return
	animeShooting()
	
func on_focus(focus):
	set_process_input(focus)

func on_getKeyItem(repair):
	keyItem += 1
	on_coolerRepair(repair)
	get_tree().call_group("system","on_gotKey",keyItem,keyItemRequest)
	if keyItem >= keyItemRequest:
		get_tree().call_group("system","on_readyToEsc")

func on_nightStarted():
	$frontLight.energy = 0.85

func on_dayStarted():
	$frontLight.energy = 0

func animePlayerGetout():
	$Ani.play("OutShip")
	$Stat/StatAni.play("StatOutit")
	$gungateAni.play("close")
	$gun/gunAni.play("hoverDown")

func animePlayerGetin():
	$Stat/StatAni.play("StatInit")
	$Ani.play("GetOnShip")
	$gungateAni.play("open")
	$gun/gunAni.play("hoverUp")
	await get_tree().create_timer(0.3).timeout
	$Stat/StatAni.play("StatHover")

func animeShooting():
	$Ani.play("attack")
	await get_tree().create_timer(0.15).timeout
	$Ani.play("OnShip")
