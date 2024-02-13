extends VBoxContainer



#this 3 brake the cards poss, may fix if i get the anchor working right
func _on_act_1_hide_pressed():
	return
	$act1.visible = !$act1.visible

func _on_act_21_hide_pressed():
	return
	$"act2-1".visible = !$"act2-1".visible

func _on_act_22_hide_pressed():
	return
	$"act2-2".visible = !$"act2-2".visible

func _on_act_3_hide_pressed():
	return
	$act3.visible = !$act3.visible

