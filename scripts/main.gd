extends Node2D

@export var enemy:PackedScene
@export var ship:PackedScene

var map = preload("res://sceen/map_tutorial.tscn")
var mapIns

var gameover = preload("res://sceen/gameOver.tscn")
var isGameOver = false

func _ready():
	add_to_group("bullet")
	add_to_group("dayNight")
	add_to_group("enemyAttack")
	add_to_group("system")
	on_newGame()

func _process(delta):
	pass

func on_heatUpdate(heat):
	$GUI/heatBar.value = heat

func on_dayNightUpdate(day,hour,min):
	$GUI/time.text = "Time : "+str(day)+" day " +str(hour)+" hour "+str(min)+" min"
	
func on_coolerDMGUpdate(dmg):
	$GUI/coolerDmg.text = "cooler damage : "+str(int((dmg-1)*100))+" %"

func on_nightStarted():
	if isGameOver : return
	$enemySpawnTime.start()

func on_dayStarted():
	if isGameOver : return
	$enemySpawnTime.stop()
	
func on_liquidInPlayer(liq):
	$GUI/liquid.text = "Liquid in player  : "+str(liq)

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
	$enemySpawnTime.stop()
	isGameOver = true
	
func on_newGame():
	isGameOver = false
	get_tree().call_group("dayNight","on_resetTime")
	
	var shipIns = ship.instantiate()
	mapIns = map.instantiate()
	
	add_child(mapIns)
	var pos = mapIns.get_node("shipPoint").global_position
	shipIns.position = pos
	add_child(shipIns)
	
func on_toMainMenu():
	get_tree().change_scene_to_file("res://sceen/mainMenu.tscn")
