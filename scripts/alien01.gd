extends CharacterBody2D
var NODE_NAME = "enemy"
var NODE_TYPE = "enemy"

@export var liquid:PackedScene
@export var hp:float = 100
@export var dmg:float = 0.1
@export var liquidAilen:float = 30

var ship
var walkSpeed
var canAttack = false

@onready var nav = $pathFinding

func init(shipIns,pos,speed):
	position = pos
	ship = shipIns
	walkSpeed = speed

func _ready():
	$Ani.play("Running")
	add_to_group("enemyAttack")
	add_to_group("dayNight")
	
	nav.target_position = ship.global_position

func _physics_process(delta):
	if not canAttack :
		var path = to_local(nav.get_next_path_position()).normalized()*walkSpeed
		velocity = path
	else :velocity = Vector2(0,0)
	move_and_slide()

func on_getAttacked(dmg):
	hp -= dmg
	$Ani.play("Damaged")
	if hp <= 0: 
		on_dead()
	else:
		await get_tree().create_timer(0.15).timeout
		$Ani.play("Running")

func on_dead():
	$Ani.play("Dying")
	await get_tree().create_timer(0.3).timeout
	
	var ins = liquid.instantiate()
	ins.init(liquidAilen,global_position)
	get_parent().add_child(ins)
	queue_free()

func _on_attack_delay_timeout():
	if not canAttack : 
		return
	get_tree().call_group("enemyAttack","on_coolerDamage",dmg)
	$Ani.play("Attacking")

func on_dayStarted():
	$Ani.play("Dying")
	await get_tree().create_timer(0.3).timeout
	
	on_dead()

