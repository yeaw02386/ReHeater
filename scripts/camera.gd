extends Camera2D

var noise = FastNoiseLite.new()

var noiseY = 0
var shake = 0
var decay = 0.9
var maxOffset = Vector2(10,15)
var maxRotaion = 0.05

var pos = Vector2(0,0)
var camSpeed = 5
var zoomCam = Vector2(1,1)

func _ready():
	randomize()
	add_to_group("heat")
	add_to_group("camera")
	noise.seed = randi()

func _physics_process(delta):
	if shake :
		shake = max(0,shake-decay*delta)
		shakeing()
	
	if pos :
		position = position.move_toward(pos,camSpeed)
	else :
		position = position.move_toward(pos,camSpeed/3)
		
	if zoomCam :
		zoom = zoom.move_toward(zoomCam,0.008)
	else :
		zoom = zoom.move_toward(zoomCam,0.008)

func shakeing():
	noiseY += 1
	var y = noise.get_noise_2d(10,noiseY)
	var x = noise.get_noise_2d(20,noiseY)
	offset = Vector2(x,y) * maxOffset * shake
	rotation = maxRotaion * noise.get_noise_1d(noiseY) * shake

func on_coolerDMGUpdate(dmg):
	if get_parent().NODE_TYPE != "ship":return
	shake = min(1,abs(dmg-1)*0.1)

func on_mouseMove(mouse):
	var size = get_viewport().size/2
	mouse = mouse/Vector2(size)
	
	var z = threshold(mouse,0.5)
	if z :zoomCam = Vector2(0.9,0.9)
	else: zoomCam = Vector2(1,1)
	
	pos = threshold(mouse,0.8)*100
	
func threshold(mouse,the):
	var m = mouse
	if mouse.x <= the and mouse.x >= -the:m.x = 0
	if mouse.y <= the and mouse.y >= -the:m.y = 0
	return m
