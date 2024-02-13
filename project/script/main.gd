extends Node2D

var zoom_percentage = 15
var max_zoom = 1
var max_unzoom = 0.3

var current = true

var drag_cursor_shape = false

@onready var camera = $Camera


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.final_script_content = ""
	Global.reff_main = self
	camera.zoom = Vector2(0.4, 0.4)


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

func contact(reff_selected_card):
	return null

func disengage():
	return self


@export var script_name = "script_name"

func create_file():
	var file = FileAccess.open("res://printed_scripts/"+ script_name + ".md", FileAccess.WRITE)
	file.store_string(Global.final_script_content)


func _on_print_script_pressed():
	var cards = get_tree().get_nodes_in_group("card")
	for card in cards:
		if card.designated_dedropzone_set:
			card.fetch_card_content()
	
	create_file()


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
	var node_to_save = self
	var scene = PackedScene.new()

	scene.pack(node_to_save)

	var save_path = "res://save_files/" + $save/save_path.text
	ResourceSaver.save(scene, save_path)