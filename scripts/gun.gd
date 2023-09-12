extends Node2D
@export var bulletLight:PackedScene
@export var bulletAOE:PackedScene
@export var bulletPiercing:PackedScene
var allBullet
var bullet 

var delayMetaData = {0:0.2,
					 1:1.0,
					 2:0.7}
var nowBulletType = -1
var canShoot = true

func _ready():
	allBullet = [bulletLight,bulletAOE,bulletPiercing]
	swapBullet() 

func _process(delta):
	if Input.is_action_pressed("attack") and canShoot: 
		shoot()
		canShoot = false

func shoot() :
	var ins = bullet.instantiate()
	var pos = $Polygon2D.position + get_parent().position + position
	ins.init(pos)
	get_parent().get_parent().add_child(ins)
	get_tree().call_group("heat","on_heating",ins.heatGening)

func _on_shoot_delay_timeout():
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
	
