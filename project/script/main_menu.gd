extends Node2D

func _ready():
	$Camera2D/ui/extra/ver_opt.selected = get_os()

func get_os()-> int:
	var aux = -1
	if OS.has_feature("web"):
		Global.current_os = "web"
		aux = 1
	if OS.has_feature("windows"):
		Global.current_os = "windows"
		aux = 0
	if OS.has_feature("android"):
		Global.current_os = "android"
		aux = 2
	return aux


#PRESSED____________________________________________________________________________________________

func _on_new_board_pressed():
	$move_vfx.play()
	Global.change_scene_to("res://scenes/main.tscn")
	#get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_load_board_pressed():
	$move_vfx.play()
	if Global.current_os == "web":
		Global.load_data_on_main_board = "file"
		Global.change_scene_to("res://scenes/main.tscn")
	else:
		$"Camera2D/ui/container/working_stuff/LOAD BOARD".hide()
		$Camera2D/ui/container/working_stuff/loader.show()


func _on_load_pressed():
	$move_vfx.play()
	if $Camera2D/ui/container/working_stuff/loader/path.text != "":
		var file = $Camera2D/ui/container/working_stuff/loader/path.text
		
		#if !FileAccess.file_exists(file):
		#	$error_vfx.play()
		#	return
		Global.load_data_on_main_board = file
		Global.change_scene_to("res://scenes/main.tscn")
		#get_tree().change_scene_to_file(file)


func _on_exit_pressed():
	$move_vfx.play()
	get_tree().quit()

func _on_ver_opt_item_selected(index):
	$Camera2D/ui/extra/ver_opt.selected = index

#UI_________________________________________________________________________________________________

func _on_new_board_mouse_entered():
	$place_vfx.play()

func _on_load_board_mouse_entered():
	$place_vfx.play()

func _on_exit_mouse_entered():
	$place_vfx.play()

func _on_load_mouse_entered():
	$place_vfx.play()
