extends CanvasLayer

@export_file("*.tscn") var next_scene_path: String 

func _ready():
	ResourceLoader.load_threaded_request(next_scene_path) # Starts the loading process behind the scenes


func _process(delta):
	if ResourceLoader.load_threaded_get_status(next_scene_path) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		#await get_tree().create_timer(0.25).timeout 
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene_path)
		get_tree().change_scene_to_packed(new_scene)
		#the error process((: signal is already connected to given callable container happens coss: 
		# the node instance is set to editable so it runs the signals twice. Seems like it's known godot issue. Fixed it by toggle editable off on the instance.
		#but we need this node to be editable otherwise it wont be save
		#so thats that
