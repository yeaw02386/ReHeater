extends Node2D
@export var hp:float = 100
@export var dmg:float = 0.1

var ship
var targetPos
var walkSpeed
var canAttack = false

func init(shipIns,speed):
	ship = shipIns
	targetPos = ship.position
	walkSpeed = speed

func _ready():
	add_to_group("enemyAttack")
	ship = get_parent().get_node("ship")
	init(ship,1)


func _process(delta):
	if not canAttack :
		position = position.move_toward(targetPos,walkSpeed)

func on_getAttacked(dmg):
	hp -= dmg
	if hp <= 0: 
		on_dead()

func on_dead():
	queue_free()

func _on_attack_delay_timeout():
	if not canAttack : 
		return
	get_tree().call_group("enemyAttack","on_coolerDamage",dmg)
