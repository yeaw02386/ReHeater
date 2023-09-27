extends Node2D


func _ready():
	add_to_group("audio")

func _process(delta):
	pass

func on_play(name):
	get_node(name).play()

func on_stop(name):
	get_node(name).stop()
