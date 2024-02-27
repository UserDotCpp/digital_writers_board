extends Node

var is_draggin = false
var selected_card = null
var idle_spawned_card = null
var final_script_content : String
var reff_main
var load_data_on_main_board = ""
var current_os
var soffrecovery = true
var recoveryfile = true
var vfx_bus = AudioServer.get_bus_index("vfx")
var master_bus = AudioServer.get_bus_index("Master")

func change_scene_to(target: String) -> void:
	var loading_screen = preload("res://scenes/loading_screen.tscn").instantiate()
	loading_screen.next_scene_path = target
	get_tree().current_scene.add_child(loading_screen)


