extends Node2D

var selected = false
var designated_dedropzone = null
@export var designated_dedropzone_set = false #might be redundant, it is

@export var story_beat : String
@export var color : Color = Color(0.4235, 0.4235, 0.4235, 1)

@export var intout : String
@export var place : String
@export var time  : String

@export var scene_content :String

@export var emotional_tone :String
@export var emotional_tone_content :String

@export var party_one :String
@export var party_two :String


func _ready():
	designated_dedropzone = Global.reff_main


func _on_static_body_input_event(_viewport, _event, _shape_idx):	
	if Input.is_action_just_pressed("left_click") and selected == false:
		if Global.idle_spawned_card == self:
			Global.idle_spawned_card = null
		#print(assign_zone) #deocupy here
		$move_vfx.play()
		Global.selected_card = self
		Global.is_draggin = true
		selected = true


func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and selected:
			Global.is_draggin = false
			if designated_dedropzone_set and designated_dedropzone != Global.reff_main and designated_dedropzone != null:
				var tween = get_tree().create_tween()
				print(designated_dedropzone)
				tween.tween_property(self,"global_position",designated_dedropzone.global_position,0.2).set_ease(Tween.EASE_OUT) #clamps the card to the drop zone TO DO if i get the anchors to work this is gonna be redundant
				
				$place_vfx.play()
				get_parent().remove_child(self)#removes the child here to instance it in main
				designated_dedropzone.occupy(self)

			else:
				$move_vfx.play()
		selected = false
		Global.selected_card = null


#func _on_static_body_mouse_entered():
#	if not Global.is_draggin:
		#draggable = true
#		scale = Vector2(1.05,1.05)

#func _on_static_body_mouse_exited():
#	if not Global.is_draggin:
		#draggable = true
#		scale = Vector2(1,1)


func _on_area_body_entered(body):
	if Global.selected_card != self:
		return

	#if designated_dedropzone != null: #and body.get_parent().contact(self) != designated_dedropzone:
	#	designated_dedropzone.disengage()
	var contact = body.get_parent().contact(self)

	#if designated_dedropzone != null and contact != null:
	
	
	designated_dedropzone_set = true
	
	
	#else:
	#	designated_dedropzone_set = false
	
	if contact != Global.reff_main:
		designated_dedropzone = contact
	
	
	#print("designated ",contact,"  designated_dedropzone    ",designated_dedropzone)
		
	#get_target_poss(contact.global_position)

func _on_area_body_exited(body):
	var _contact = body.get_parent().disengage()
	#print("contact  ", contact ," and  designated_dedropzone ",designated_dedropzone)
	#if contact == null:
	#	designated_dedropzone_set = false
	#	designated_dedropzone = false

	#if designated_dedropzone == contact:
	#	print("si es")
	#	if !Global.is_draggin:
	#		print("este")
	#else:
	#	print("next")

#func get_target_poss(poss) -> void:
#	body_poss_ref = poss

func fetch_card_content():
	$card_content.card_content(designated_dedropzone)

