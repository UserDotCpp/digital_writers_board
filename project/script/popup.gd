extends Panel

@onready var timer = $Timer
@export var timer_Wait_Time = 1
# Called when the node enters the scene tree for the first time.

func _ready():
	timer.wait_time = timer_Wait_Time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	$ap.play("done")

func create_poppup(content) -> void:
	timer.stop()
	$ap.play_backwards("done")
	$content.text = content
	$error_vfx.play()
	timer.start()
