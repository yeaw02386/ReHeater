extends CharacterBody2D
var mainIns = preload("res://sceen/main.tscn")
var cutsceneIns = preload("res://sceen/cutscene.tscn")

var health = 5
var panel = 0

signal fade

func process():
	pass


func on_getAttacked(dmg):
	health -= 1
	panel = health
	$button.frame = panel;
	
	if health == 0:
		$aniButplay.play("shrink")
		$button.play("break")
		emit_signal("fade")
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_packed(cutsceneIns)
		return
