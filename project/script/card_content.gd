extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$top/story_beat.text = get_parent().story_beat

	if get_parent().intout == "":
		$location_info/intOut.text = "INT"
		get_parent().intout = "OUT"
	$location_info/intOut.text = get_parent().intout
	
	$location_info/place.text = get_parent().place
	$location_info/time.text = get_parent().time
	$scene_content.text = get_parent().scene_content
	
	if get_parent().emotional_tone == "":
		$emotional_changes/emotional_tone.text = "+/-"
		get_parent().emotional_tone = "+/-"
	$emotional_changes/emotional_tone.text = get_parent().emotional_tone
	
	$emotional_changes/emotional_tone_content.text = get_parent().emotional_tone_content
	$conflict/party_one.text = get_parent().party_one
	$conflict/party_two.text = get_parent().party_two



func card_content(reff_designated_dedropzone) -> void:
	
	var location_info
	location_info = $location_info/intOut.text + " - " + $location_info/place.text + " - " + $location_info/time.text
	
	var scene_content
	scene_content = $scene_content.text

	var emotional_changes
	emotional_changes = $emotional_changes/emotional_tone.text +"	" + $emotional_changes/emotional_tone_content.text
	
	var conflict = "><	" + $conflict/party_one.text + "	,	" + $conflict/party_two.text
	
	Global.final_script_content = Global.final_script_content + ("on the "+ str(reff_designated_dedropzone) + "
	") +(location_info + "
	") +("		" + emotional_changes + "		" + conflict + "
	") +("	" + scene_content + "
	") +("
	") +("")

func _on_story_beat_text_changed(new_text):
	get_parent().story_beat = new_text

func _on_intout_text_changed(new_text):
	get_parent().intout = new_text

func _on_int_out_pressed():
	if $location_info/intOut.text == "INT" :
		$location_info/intOut.text = "OUT"
	else:
		$location_info/intOut.text = "INT"
	get_parent().intout = $location_info/intOut.text


func _on_place_text_changed(new_text):
	get_parent().place = new_text


func _on_time_text_changed(new_text):
	get_parent().time = new_text


func _on_scene_content_text_changed():
	get_parent().scene_content = $scene_content.text


func _on_emotional_tone_pressed():
	if $emotional_changes/emotional_tone.text == "+/-" :
		$emotional_changes/emotional_tone.text = "-/+"
	else:
		$emotional_changes/emotional_tone.text = "+/-"
	get_parent().emotional_tone = $emotional_changes/emotional_tone.text


func _on_emotional_tone_content_text_changed(new_text):
	get_parent().emotional_tone_content = new_text


func _on_party_one_text_changed(new_text):
	get_parent().party_one = new_text


func _on_party_two_text_changed(new_text):
	get_parent().party_two = new_text



