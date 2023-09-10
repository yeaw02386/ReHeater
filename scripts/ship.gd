extends Node2D

var MAX_HEAT = 1000
var heat = 30
var coolerDMG = 1
var heatLimit = []

func _ready():
	pass

func _process(delta):
	pass
	
func on_heating(temp) :
	heat += temp*coolerDMG
	if heat <= MAX_HEAT :
		get_tree().call_group("heat","on_destroy")

func on_cooling(temp) :
	heat -= temp

func _input(event):
	if event.is_action_pressed("aoeGun") :
		pass
		
func on_setHeatLimit(temp) :
	heatLimit.append(temp)

