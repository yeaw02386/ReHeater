extends Node2D

var keyItem = load("res://sceen/KeyItem.tscn")

var keyReq = 0
var keyPoint = []
var spawnPoint = []
var isGen = false

func _ready():
	keyPoint.shuffle()
	add_to_group("system")
	add_to_group("map")

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


func _on_spawn_point_child_entered_tree(node):
	spawnPoint.append(node.global_position)

func on_entityUpdate(pos,ent):
	var coor = $TileMap.local_to_map(pos)
	if coor == ent.prevTilePos: return
	ent.prevTilePos = coor
	
	var cell = $TileMap.get_cell_tile_data(1,coor)
	if not cell : return
	if $TileMap.map_to_local(coor).y < pos.y: 
		cell.z_index = 0
	else :
		cell.z_index = 2
	
