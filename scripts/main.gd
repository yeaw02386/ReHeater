extends Node2D

@export var enemy:PackedScene

func _ready():
	var playerIns = get_node("ship").playerIns
	add_child(playerIns)

func _process(delta):
	pass

func on_heatUpdate(heat):
	$GUI/heatBar.value = heat

func on_dayNightUpdate(day,hour,min):
	$GUI/time.text = "Time : "+str(day)+" day " +str(hour)+" hour "+str(min)+" min"
	
func on_coolerDMGUpdate(dmg):
	$GUI/coolerDmg.text = "cooler damage : "+str(int((dmg-1)*100))+" %"

func on_nightStarted():
	$enemySpawnTime.start()

func on_dayStarted():
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
