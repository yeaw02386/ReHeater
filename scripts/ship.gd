extends Node2D

var MAX_HEAT = 1000
var heat = 400
var coolerDMG = 1
var heatLimit = []

func _ready():
	add_to_group("heat")
	add_to_group("enemyAttack")

func _process(delta):
	pass
	
func on_heating(temp) :
	heat += temp*coolerDMG
	if heat <= MAX_HEAT :
		get_tree().call_group("heat","on_destroy")

func on_cooling(temp) :
	heat -= temp
		
func on_setHeatLimit(temp) :
	heatLimit.append(temp)
	
func on_coolerDamage(dmg) :
	coolerDMG += dmg

func _on_hitbox_area_entered(area):
	area.get_parent().canAttack = true
