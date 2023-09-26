extends Node2D
@export var bulletLight:PackedScene
@export var bulletAOE:PackedScene
@export var bulletPiercing:PackedScene
var allBullet
var bullet 

signal fired

var delayMetaData = {0:0.2,
					 1:1.3,
					 2:0.7}
var nowBulletType = -1
var canShoot = false
var playerInShip = false
var isFocus = true

func _ready():
	$particleAni.play("default")
	add_to_group("gun")
	add_to_group("system")
	add_to_group("audio")
	allBullet = [bulletLight,bulletAOE,bulletPiercing]
	swapBullet() 

func _process(delta):
	if (Input.is_action_pressed("attack") and 
								canShoot and 
								playerInShip and 
								isFocus): 
		$particleAni.play("shoot")
		canShoot = false
		$shootDelay.start()
		shoot()

func shoot() :
	get_tree().call_group("gun","on_playShoot")
	get_tree().call_group("audio","on_play","shoot")
	var ins = bullet.instantiate()
	var pos = global_position
	ins.init(pos)
	get_parent().get_parent().add_child(ins)
	get_tree().call_group("heat","on_heating",ins.heatGening)

func _on_shoot_delay_timeout():
	$particleAni.play("default")
	canShoot = true
		
func _input(event):
	if event.is_action_pressed("swapBullet") :
		swapBullet()
		
func swapBullet():
	nowBulletType += 1
	if nowBulletType == 3 :
		nowBulletType = 0
	
	bullet = allBullet[nowBulletType]
	$shootDelay.wait_time = delayMetaData.get(nowBulletType)
	
func on_focus(focus):
	set_process_input(focus)
	isFocus = focus
