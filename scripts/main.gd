extends Node2D

@export var enemy:PackedScene
@export var ship:PackedScene
@export var keyItemRequest : int = 3

var mapIns

var gameover = preload("res://sceen/gameOver.tscn")
var miniMap = preload("res://sceen/miniMap.tscn")
var panel = preload("res://sceen/panel.tscn")
var isGameOver = false
var shipPos = null
var shipIns = null

func _ready():
	add_to_group("bullet")
	add_to_group("dayNight")
	add_to_group("enemyAttack")
	add_to_group("system")
	add_to_group("gun")
	on_newGame()

func _process(delta):
	pass

<<<<<<< Updated upstream
=======
func on_heatUpdate(heat):
	$GUI/heatBar.value = heat

func on_dayNightUpdate(day,hour,min):
	#$GUI/time.text = "Time : "+str(day)+" day " +str(hour)+" hour "+str(min)+" min"
	$GUI/time.text = str(hour) + " : " + str(min)
	$GUI/date.text = "Day   " + str(day)
	
func on_coolerDMGUpdate(dmg):
	$GUI/coolerDmg.text = "cooler damage : "+str(int((dmg-1)*100))+" %"

>>>>>>> Stashed changes
func on_nightStarted():
	if isGameOver : return
	$enemySpawnTime.start()

func on_dayStarted():
	if isGameOver : return
	$enemySpawnTime.stop()

func on_heatUpdate(heat):
	$GUI/heatBar.value = heat

func _on_enemy_spawn_time_timeout():
	spawnEnemy()

func spawnEnemy():
	var spawnPoint = $enemyPath/sapwnPath
	spawnPoint.progress_ratio = randf()
	var pos = spawnPoint.position
	var speed = randi_range(60,100)
	var ship = get_node("ship")
	
	var ins = enemy.instantiate()
	ins.init(ship,pos,speed)
	add_child(ins)

func on_destroy():
	if isGameOver: 
		return
		
	add_child(gameover.instantiate())
	shipIns = null
	$enemySpawnTime.stop()
	isGameOver = true
	
func on_newGame():
	add_child(miniMap.instantiate())
	add_child(panel.instantiate())
	get_tree().call_group("system","changeMap","map1")
	
	isGameOver = false
	get_tree().call_group("dayNight","on_resetTime")
	
	shipIns = ship.instantiate()
	shipIns.init(shipPos,keyItemRequest)
	add_child(shipIns)
	
func on_toMainMenu():
	get_tree().change_scene_to_file("res://sceen/mainMenu.tscn")

func on_mapChange(m):
	$GUI/minimap.button_pressed = false
	$GUI/watch.button_pressed = false
	add_child(m)
	if mapIns : remove_child(mapIns)
	mapIns = m
	if !shipIns :
		shipPos = mapIns.get_node("shipPoint").global_position
		return
	
	shipPos = mapIns.get_node("shipPoint").global_position
	shipIns.position = shipPos

func _on_minimap_toggled(button_pressed):
	$miniMap.visible = button_pressed
	get_tree().call_group("system","on_focus",!button_pressed)

func on_isPlayerGetout(out):
	$GUI/minimap.visible = !out
	
func _on_watch_toggled(button_pressed):
	$panel.visible = button_pressed
	get_tree().call_group("system","on_focus",!button_pressed)
