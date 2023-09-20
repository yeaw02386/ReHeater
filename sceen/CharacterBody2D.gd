extends CharacterBody2D

var health = 5
var panel = 0

func process():
	pass


func on_getAttacked(dmg):
	health -= 1
	panel = health
	$button.frame = panel;
	
	if health == 0:
		$aniButquit.play("shrink")
		$button.play("break")
		await get_tree().create_timer(0.5).timeout
		
		get_tree().quit()
		return
