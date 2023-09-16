extends Label

var fadeOut = false
var exit

func init(txt,time):
	text = txt
	$Timer.wait_time = time

func _ready():
	pass

func _process(delta):
	if fadeOut :
		position = position.move_toward(exit,5)

func _on_timer_timeout():
	get_parent().get_parent().on_textUpdate(text)
	exit = position+Vector2(300,0) 
	$timefade.start()
	fadeOut = true

func _on_timefade_timeout():
	queue_free()
