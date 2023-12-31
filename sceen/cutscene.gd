extends Node2D
var frame = 5
var mainIns = preload("res://sceen/main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$AniPlayer.play("expand")
	await get_tree().create_timer(0.5).timeout
	
func _process(delta):
	
		
	if Input.is_action_just_pressed("attack"):
		if frame == 0:
				$AniPlayer.play("shrink")
				await get_tree().create_timer(0.5).timeout
				$AniPlayer.play("fade out")
				await get_tree().create_timer(0.5).timeout
				get_tree().change_scene_to_packed(mainIns)
		else :
			frame -= 1
			$AniPlayer.play("shrinkpand")
			await get_tree().create_timer(0.5).timeout
			$frame.frame = frame
		

func _on_skip_pressed():
	get_tree().change_scene_to_packed(mainIns)
