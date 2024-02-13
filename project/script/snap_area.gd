extends Container

var is_targeted = false

@export var occupied = false
var occupied_card = null

@onready var the_panel = $Panel


func _process(_delta):
	if occupied:
		the_panel.modulate = Color(0, 0, 0, 0.5)
	else:
		if Global.is_draggin and !is_targeted:
			the_panel.modulate = Color(1, 1, 1, 0.1137) 
		else:
			the_panel.modulate = Color(0.4922, 0.4922, 0.4922, 0.1824)


func vacant() -> void:
	the_panel.modulate = Color(1, 1, 1, 0.1137)
	is_targeted = false

func targeted() -> void:
	is_targeted = true
	the_panel.modulate = Color(Color.FOREST_GREEN, 0.1137)

func can_be_occupied() -> void:
	the_panel.modulate = Color(1, 1, 1, 1)
	is_targeted = false


func contact(_reff_selected_card):
	if occupied:#if the card passes over a spot occupied by an existent card
		return Global.reff_main #this make it so a card can be deposit in its own occupied spot
	else:
		targeted()
		return self
	

func disengage():
	if !occupied:
	#	occupied = false
		vacant()
		return self

var scene_card

func occupy(reff_selected_card):
	scene_card = reff_selected_card
	$drop_point.add_child(scene_card) #if the child dropped in drop zone it'll be still alaing when closing an act
	#scene_card.scene_file_path=''
	scene_card.owner = Global.reff_main #makes it local in code, this is dark magic do not touch
	
	occupied = true
	occupied_card = reff_selected_card

func de_occupy():
	occupied = false
	occupied_card = false

func _on_drop_point_child_exiting_tree(node):
	de_occupy()
