extends Node2D

#camerera
var zoom_percentage = 15
var max_zoom = 1
var max_unzoom = 0.3
@onready var camera = $Camera

#MOUSE
var current = true ##might be redundant
var drag_cursor_shape = false

var rng = RandomNumberGenerator.new()

@onready var staple_vfx = $staple_vfx

@export var script_name = "script_name" #name of the markdown file



func _ready():
	Global.final_script_content = ""
	Global.reff_main = self
	#camera.zoom = Vector2(0.4, 0.4)
	change_below_ui_status(true)
	change_top_ui_status(true)
	if Global.load_data_on_main_board != "":
		if Global.current_os != "web":
			load_file_data_html()
		else:
			load_file_data_windows()
		Global.load_data_on_main_board = ""


func _process(_delta):
	if current:
		if drag_cursor_shape:
			DisplayServer.cursor_set_shape(DisplayServer.CURSOR_DRAG)


func _input(event):
	if current:
		if event is InputEventMouseMotion:
			if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
				camera.position -= event.relative / camera.zoom
				drag_cursor_shape = true
			else:
				drag_cursor_shape = false
		if event is InputEventMouseButton:
			if event.is_pressed():
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					camera.zoom += Vector2.ONE * zoom_percentage / 100
					if camera.zoom.x > max_zoom:
						camera.zoom = Vector2.ONE * max_zoom
						return
					camera.position += get_local_mouse_position() / 10
				if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					camera.zoom -= Vector2.ONE * zoom_percentage / 100
					if camera.zoom.x < max_unzoom:
						camera.zoom = Vector2.ONE * max_unzoom


#PRESSED____________________________________________________________________________________________

func _on_print_script_pressed():
	var cards = get_tree().get_nodes_in_group("card")
	staple_vfx.pitch_scale = rng.randf_range(0.95, 1.15)
	staple_vfx.play()
	for card in cards:
		if card.designated_dedropzone_set:
			card.fetch_card_content()
	match Global.current_os:
		"windows":
			create_file_windows()
		"web":
			create_file_html()

var scene_card = preload("res://scenes/scene_card.tscn")

var car_index = 0

func _on_spawner_button_pressed():
	if Global.idle_spawned_card != null:
		$spawner/error_vfx.play()
		return
	$spawner/spawn_vfx.play()
	var card_instance = scene_card.instantiate()
	#card_instance.scene_file_path=''
	#card_instance.owner=self#get_tree().get_edited_scene_root()
	#card_instance.global_position = $spawner/spawn_location.global_position
	car_index += 1
	card_instance.name = "card" + str(car_index)
	Global.idle_spawned_card = card_instance
	$spawner.add_child(card_instance)


func _on_save_pressed():
	staple_vfx.pitch_scale = rng.randf_range(0.95, 1.15)
	staple_vfx.play()
	#var node_to_save = self
	#var scene = PackedScene.new()
	#scene.pack(node_to_save)
	#var save_path = "res://save_files/" + $Camera/ui/top/LeftRight/save/save_path.text
	#ResourceSaver.save(scene, save_path)
	if $Camera/ui/top/LeftRight/save/save_path.text != "":
		match Global.current_os:
			"windows":
				save_file_windows($Camera/ui/top/LeftRight/save/save_path.text)
			"web":
				save_file_html($Camera/ui/top/LeftRight/save/save_path.text)

#UI_________________________________________________________________________________________________
func _on_area_top_mouse_entered():
	$move_vfx.play()
	change_top_ui_status(false)


func _on_area_top_mouse_exited():
	change_top_ui_status(true)


func change_top_ui_status(status) -> void:
	$Camera/ui/top/hider.visible = !status
	$Camera/ui/top/LeftRight/print_script.disabled = status
	$Camera/ui/top/LeftRight/save.disabled = status


func _on_area_below_mouse_entered():
	$move_vfx.play()
	change_below_ui_status(false)


func _on_area_below_mouse_exited():
	change_below_ui_status(true)


func change_below_ui_status(status) -> void:
	$Camera/ui/below/hider.visible = !status
	$Camera/ui/below/LeftRight/spawner_button.disabled = status
	$Camera/ui/below/LeftRight/back.disabled = status


func _on_back_pressed():
	Global.change_scene_to("res://scenes/main_menu.tscn")
	#get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


#FILE MANAGMENT____________________________________________________________________________________
#temporary test
func Save_PNG(_file,_path,_filename):
	var _err = _file.save_png(_path+"/"+_filename+".txt")
	Download_File(_path+"/"+_filename+".txt",_filename)
		#Put Error Handling Here
#temporary test
func Download_File(_path,_filename):
	var f = FileAccess.open("C:/Users/user/Desktop/STC_exports/"+"script_name" + ".txt", FileAccess.READ)
	var buf = f.get_buffer(f.get_len())
	print(buf)
	JavaScriptBridge.download_buffer(buf,_filename+".txt")
	f.close()



func create_file_windows():
	#var file = FileAccess.open("res://printed_scripts/"+ script_name + ".md", FileAccess.WRITE)
	#file.store_string(Global.final_script_content)
	var dir=DirAccess.open("user://")
	dir.make_dir("C:/Users/user/Desktop/STC_exports")

	var file = FileAccess.open("C:/Users/user/Desktop/STC_exports/"+"script_name" + ".txt", FileAccess.WRITE)
	file.store_string(Global.final_script_content)


func create_file_html() -> void:
	if OS.has_feature("web"):
		var text = str(Global.final_script_content)
		#var buf = file.get_buffer(Global.final_script_content.length())
		JavaScriptBridge.download_buffer(text.to_utf8_buffer (),  "%s.txt" % "my_filename", "text/plain")


func save_file_windows(file_name) -> void:

	var dir=DirAccess.open("user://")
	dir.make_dir("C:/Users/user/Desktop/STC_exports")



	var save_game = FileAccess.open("C:/Users/user/Desktop/STC_exports/" + file_name + ".save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")

	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(json_string)


func load_file_data_windows():


	if not FileAccess.file_exists("C:/Users/user/Desktop/STC_exports/" + Global.load_data_on_main_board + ".save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_game = FileAccess.open("C:/Users/user/Desktop/STC_exports/" + Global.load_data_on_main_board + ".save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			if i == "color":
				new_object.set(i, Color.html(node_data[i]))
				continue
			new_object.set(i, node_data[i])
		new_object.fetch_card_content()


func save_file_html(file_name) -> void:	
	var save_nodes = get_tree().get_nodes_in_group("Persist")

	var export = ""

	for node in save_nodes:
	# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)
		export = export + json_string
		# Store the save dictionary as a new line in the save file.
		#save_game.store_line(json_string)
		
	JavaScriptBridge.download_buffer(export.to_utf8_buffer (),  "%s.save" % file_name, "text/plain")










func load_file_data_html():
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	#var save_game = FileAccess.open("C:/Users/user/Desktop/STC_exports/" + Global.load_data_on_main_board + ".save", FileAccess.READ)
	
	
	HTML5File.load_file()
	var content = await HTML5File.load_completed
	#var json_content = JSON.parse(content,true)
	#json_content = content
	var file = FileAccess.open("res://save.save", FileAccess.WRITE)
	file.parse(content,true)
	#file.store_string(content)
	
	file.close()
	#var save_game = JSON.parse_string(content)
	#(content) 
	file.open("res://save.save", FileAccess.READ)
	
	
	print(file)
	while file.get_position() < file.get_length():
		var json_string = file.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			if i == "color":
				new_object.set(i, Color.html(node_data[i]))
				continue
			new_object.set(i, node_data[i])
		new_object.fetch_card_content()







#temporary test
func _on_upload_button_pressed():
	if Global.current_os != "web":
		return
	HTML5File.load_file()
	var content = await HTML5File.load_completed
	$the_exit.text = content
	#load_file_data_html()




#mandatory coss of snap_area stuff__________________________________________________________________
func get_drop_point_path():
	return $drop_point.get_path()
func contact(_reff_selected_card):
	return null
func disengage():
	return self
