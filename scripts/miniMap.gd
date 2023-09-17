extends CanvasLayer

var allMap = []
var mapPath = "res://sceen/map/"
var mapName = []
var currentMap
var currentName
var currentPoint = null
var currentNode
var ship 
var heat
var time
var dis
var heatUse
var timeUse
var timeArrive
var canTravel = true

func _ready():
	ship = $ship
	currentNode = get_node("map_tutorial")
	add_to_group("system")
	add_to_group("dayNight")
	add_to_group("heat")
	mapLoading() 

func _process(delta):
	pass

func mapLoading():
	var dir = DirAccess
	var mapdir = dir.get_files_at(mapPath)
	
	for i in mapdir :
		mapName.append(i.split(".")[0])
		
		var map = load(mapPath+i)
		allMap.append(map)

func _on_hit_mouse_entered(n):
	currentPoint = n
	posChecker()

func changeMap(name):
	var i = mapName.find(name)
	currentMap = allMap[i]
	currentName = name
	get_tree().call_group("system","on_mapChange",currentMap)
	ship.position = currentNode.position
	visible = false

func _on_hit_mouse_exited():
	currentPoint = null
	$dis.visible = false
	$cant.visible = false
	dataShow(false)

func drawLine(points):
	$dis.clear_points()
	for i in points:
		$dis.add_point($dis.to_local(i))
	$dis.visible = true
	
func posChecker():
	if currentName != currentPoint: 
		currentNode = get_node(currentPoint)
		drawLine([currentNode.position,ship.position])
		dataShow(true)

func dataShow(show):
	if not show :
		$data/hour.text = "Time use : "
		$data/time.text = "Will Arrive : "
		$to.value = 0
		$from.value = 0
		return
	
	calData()
	isCanTravel()
	
	if timeArrive > 23 :
		$data/time.text = "Will Arrive : tomorrow "+str(timeArrive%24)+" : "+str(time[2])
	else :
		$data/time.text = "Will Arrive : tomorrow "+str(timeArrive)+" : "+str(time[2])
	
	$data/hour.text = "Time use : "+str(timeUse) + " hour"
	$to.value = heat+heatUse
	$from.value = heat

func on_heatUpdate(h):
	heat = h

func on_dayNightUpdate(d,h,m):
	time = [d,h,m]

func calData():
	dis = currentNode.position.distance_to(ship.position)
	heatUse = dis * 0.25
	timeUse = int(dis * 0.005)
	timeArrive = timeUse+time[1]

func _input(event):
	if event.is_action_pressed("attack") and currentPoint and canTravel:
		changeMap(currentPoint)
		payCost()

func isCanTravel():
	if timeArrive > 17 or time[1] < 7:
		$cant.text = "!! Traveling not Allow !!\n Only travel in day time"
		$cant.visible = true
		canTravel = false
	elif heatUse+heat>=1000:
		$cant.text = "!! Traveling not Allow !!\n Reactor so hot"
		$cant.visible = true
		canTravel = false
	else : canTravel = true
	
func payCost():
	get_tree().call_group("dayNight","on_addTime",timeUse)
	get_tree().call_group("heat","on_heating",heatUse)
