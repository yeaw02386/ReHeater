extends Node2D

var MAX_HEAT = 1000
var heat = 30

func _ready():
	pass

func _process(delta):
	pass
	
func heating(var temp) :
	heat += temp
	if heat <= MAX_HEAT :
