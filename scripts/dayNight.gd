extends CanvasModulate

@export var gradientDayNight: GradientTexture1D
@export var timeSpeed = 1.0
@export var timeInit = 5
@export var dayStart:int = 6
@export var nightStart:int = 17

const MIN_PRE_DAY = 1440
const MIN_PRE_HOR = 60
const INGAME_TO_REAL = (2*PI)/MIN_PRE_DAY

var time = 0.0

func _ready():
	add_to_group("dayNight")
	on_resetTime()

func _physics_process(delta):
	time += delta * INGAME_TO_REAL * timeSpeed
	var value = (sin(time-PI/2)+1.0)/2
	self.color = gradientDayNight.gradient.sample(value)
	
	calTime()

func calTime():
	var totalMin = int(time/INGAME_TO_REAL)
	var currentMin = totalMin%MIN_PRE_DAY
	
	var day = int(totalMin/MIN_PRE_DAY)
	var hour = int(currentMin/MIN_PRE_HOR)
	var min = int(currentMin%MIN_PRE_HOR)
	
	get_tree().call_group("dayNight","on_dayNightUpdate",day,hour,min)
	
	if hour == dayStart:
		get_tree().call_group("dayNight","on_dayStarted")
	elif hour == nightStart:
		get_tree().call_group("dayNight","on_nightStarted")
		
func on_resetTime():
	time = timeInit * MIN_PRE_HOR * INGAME_TO_REAL
