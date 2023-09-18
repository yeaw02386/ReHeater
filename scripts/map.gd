extends Node2D

@export var keyItem : PackedScene

var keyReq = 0
var keyPoint = []
var isGen = false

func _ready():
	keyPoint.shuffle()
	add_to_group("system")

func _process(delta):
	if not isGen :
		genKeyItem()
		isGen = true

func on_getKey():
	keyReq += 1

func genKeyItem():
	for i in range(keyReq):
		if keyPoint.is_empty() : return
		
		var point = keyPoint.pop_back()
		var ins = keyItem.instantiate()
		ins.init(point.global_position)
		add_child(ins)

func _on_tile_map_child_entered_tree(node):
	keyPoint.append(node)
