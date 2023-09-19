extends CanvasLayer

func _ready():
	add_to_group("heat")
	add_to_group("system")
	add_to_group("dayNight")
	add_to_group("radar")
	on_gotKey(0,3)
	on_liquidInPlayer(0)

func _process(delta):
	pass

func on_coolerDMGUpdate(dmg):
	$Title/coolerDmg.text = "cooler damage : "+str(int((dmg-1)*100))+" %"
	if int((dmg-1)*100) > 50 :
		$quest/survive.text = "Ship's status : slightly damaged"
	elif int((dmg-1)*100) > 250 :
		$quest/survive.text = "Ship's status : damaged"
	elif int((dmg-1)*100) > 500 :
		$quest/survive.text = "Ship's status : internal damaged"
	elif int((dmg-1)*100) > 800 :
		$quest/survive.text = "Ship's status : critical damaged"
		
		

func on_dayNightUpdate(day,hour,min):
	$Title/time.text = "Time : "+str(day)+" day " +str(hour)+" hour "+str(min)+" min"

func on_liquidInPlayer(liq):
	$Title/liquid.text = "Liquid in player  : "+str(liq)

func on_gotKey(now,key):
	$quest/findPart.text = "Repair part : "+str(now)+"/"+str(key)

func on_dayStarted():
	$quest/survive.visible = false
	
func on_nightStarted():
	$quest/survive.visible = true
	
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
