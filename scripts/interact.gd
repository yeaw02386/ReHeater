extends CanvasLayer
@export var label:PackedScene
@export var timeout = 2

var allText = []
func _ready():
	add_to_group("interact")

func _process(delta):
	pass

func on_showInteract(txt):
	if allText.has(txt): return
	allText.append(txt)
	
	var ins = label.instantiate()
	ins.init(txt,timeout)
	$interactBox.add_child(ins)

func on_textUpdate(txt):
	allText.erase(txt)
