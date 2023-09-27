extends Node2D

func _ready():
	$buttonPlay.self_modulate = "#ffffff"
	$Ani.play("OnShip")
	$aniPlayer.play("shipHover")
	$gun.playerInShip = true
	pass 

func _process(delta):
	if Input.is_action_just_pressed("swapBullet"):
		$hint.visible = false
	pass

func _on_start_pressed():
	pass
	#get_tree().change_scene_to_packed(mainIns)
	
func _on_exit_pressed():
	get_tree().quit()

func on_getAttacked(dmg):
	pass

func _on_character_body_2d_fade():
	$fade/fadeAni.play("fade")
