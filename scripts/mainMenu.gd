extends Node2D
var mainIns = preload("res://sceen/main.tscn")

func _ready():
	pass 

func _process(delta):
	pass

func _on_start_pressed():
	get_tree().change_scene_to_packed(mainIns)
	
func _on_exit_pressed():
	get_tree().quit()
