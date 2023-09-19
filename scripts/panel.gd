extends CanvasLayer

func _ready():
	add_to_group("heat")
	add_to_group("system")
	add_to_group("dayNight")
	add_to_group("radar")

func _process(delta):
	pass

func on_coolerDMGUpdate(dmg):
	$coolerDmg.text = "cooler damage : "+str(int((dmg-1)*100))+" %"

func on_dayNightUpdate(day,hour,min):
	$time.text = "Time : "+str(day)+" day " +str(hour)+" hour "+str(min)+" min"

func on_liquidInPlayer(liq):
	$liquid.text = "Liquid in player  : "+str(liq)

func on_gotKey(now,key):
	$quest/findPart.text = "Repair path request : "+str(now)+"/"+str(key)

func on_dayStarted():
	$quest/surive.visible = false
	
func on_nightStarted():
	$quest/surive.visible = true
	
func on_readyToEsc():
	$quest/toesc.visible = true
	$quest/findPart.visible = false

func on_heatUpdate(heat):
	if heat > 700:
		$quest/cooldown.visible = true
	else : $quest/cooldown.visible = false

func on_keyItemDistance(dis):
	pass

func on_mapChange(m):
	visible = false

func on_destory():
	queue_free()
