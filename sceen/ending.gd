extends Node2D
var frame = 7
#var mainIns = preload("res://sceen/mainMenu.tscn")
var cutend = false

# Called when the node enters the scene tree for the first time.
func _ready():
	frame = 7
	$frame.frame = 7
	$credit.visible = false
	$AniPlayer.play("expand")
	await get_tree().create_timer(0.5).timeout
	
	add_to_group("system")
	
func _process(delta):
		
	if Input.is_action_just_pressed("attack"):
		if cutend == true:
			get_tree().change_scene_to_file("res://sceen/mainMenu.tscn")
			#get_tree().change_scene_to_packed(mainIns)
			queue_free()
		elif frame == 0:
				$AniPlayer.play("shrink")
				await get_tree().create_timer(0.5).timeout
				$frame.visible = false
				$AniPlayer.play("credit fade in")
				cutend = true
		else :
			frame -= 1
			$AniPlayer.play("shrinkpand")
			await get_tree().create_timer(0.5).timeout
			$frame.frame = frame
		

func _on_skip_pressed():
	pass
	#get_tree().change_scene_to_packed(mainIns)
