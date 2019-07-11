extends Node

class_name GDWeaponsLongAction  
 
signal began()
signal ended()
signal cancelled()
signal premature_start_attempt()
signal can_act_again()

var is_acting = false
var actions_interupt_start = []
var actions_interupt_end = []

func _ready():
	pass

func add_action_to_interupt_start(long_action):
	actions_interupt_start.append(long_action)
	long_action.connect("ended", self, "_check_can_start")

func remove_action_to_interupt_start(long_action):
	long_action.disconnect("ended", self, "_check_can_start")
	var index = actions_interupt_start.find(long_action)
	actions_interupt_start.remove(index)

	
# func add_action_to_interupt_end(long_action):
# 	actions_interupt_end.append(long_action)
# 	long_action.connect("ended", self, "_check_can_start")

# func remove_action_to_interupt_start(long_action):
# 	long_action.disconnect("ended", self, "_check_can_start")
# 	var index = actions_interupt_start.find(long_action)
# 	actions_interupt_start.remove(index)

func _check_can_start():
	if can_start_action():
		emit_signal("can_start_action_again")

func _check_can_end():
	if can_start_action():
		emit_signal("can_send_action_again")
				
func can_start_action():
	var can_start = not is_acting
	for action in actions_interupt_start:
		can_start = can_start and action.can_end_action()
	return can_start

func can_end_action():
	var can_end = not is_acting
	for action in actions_interupt_end:
		can_end = can_end and action.can_end_action()
	return can_end

func start_action():
	if(!can_start_action()):
		emit_signal("premature_start_attempt")
		return
	_apply_start_action()

func end_action():
	if(!can_end_action()):
		cancel_action()
		return
	_apply_end_action()

func cancel_action():
	if(!is_acting):
		return
	_apply_cancel_action()

func _apply_cancel_action():
	is_acting = false
	emit_signal("cancelled")
	
func _apply_end_action():
	is_acting = false
	emit_signal("ended")
	
func _apply_start_action():
	is_acting = true
	emit_signal("began")

func reset():
	is_acting = false;
	# TODO:  clear interupting actions? these likely only need to be done once as setup so may not be necessary