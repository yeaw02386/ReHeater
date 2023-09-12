extends Node2D

var MAX_HEAT = 1000
var heat = 400
var coolerDMG = 1

func _ready():
	add_to_group("heat")
	add_to_group("enemyAttack")
	
	on_heating(0)
	on_coolerDamage(0)

func _process(delta):
	pass
	
func on_heating(temp) :
	heat += temp*coolerDMG
	if heat <= MAX_HEAT :
		get_tree().call_group("heat","on_destroy")
	get_tree().call_group("heat","on_heatUpdate",heat)

func on_cooling(temp) :
	get_tree().call_group("heat","on_heatUpdate",heat)
	heat -= temp
	
func on_coolerDamage(dmg) :
	coolerDMG += dmg
	get_tree().call_group("heat","on_coolerDMGUpdate",coolerDMG)



func _on_hitbox_body_entered(body):
	body.canAttack = true
