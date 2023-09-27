extends Control
@export var bgColor:GradientTexture1D

var bgGrad = 0

func _ready():
	add_to_group("system")
	add_to_group("audio")
	get_tree().call_group("audio","on_play","bgmGameOver")

func _physics_process(delta):
	if bgGrad <= 1:
		$CanvasLayer/bg.color = bgColor.gradient.sample(bgGrad)
		bgGrad += delta

func _on_button_pressed():
	get_tree().call_group("audio","on_stop","bgmGameOver")
	get_tree().call_group("system","on_newGame")
	queue_free()


func _on_main_menu_pressed():
	get_tree().call_group("audio","on_stop","bgmGameOver")
	get_tree().call_group("system","on_toMainMenu")
	queue_free()
