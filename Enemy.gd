extends Node2D

var CP: int = 0
var LP: int = 1
var CP_max: int = 3
var LP_max: int = 1

var action_code: int 
signal aif

var zero_cp_action: Array[int] = [1,3]
var less_cp_acton: Array[int] = [1,2,3]
var max_cp_action: Array[int] = [1,2,3,4,5]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var cp_text: String = 'CP: %d / %d' % [CP, CP_max]
	var lp_text: String = 'LP: %d / %d' % [LP, LP_max]
	$Char_State/State/LP/Label.text = lp_text
	$Char_State/State/CP/Label.text = cp_text
	$Char_State/State/LP.max_value = LP_max
	$Char_State/State/LP.value = LP
	$Char_State/State/CP.max_value = CP_max
	$Char_State/State/CP.value = CP
	
	if $"../Enemy".CP < 2:
		$"../UI/ButtonContainer/HBoxContainer2/Steal".disabled = true
	else:
		$"../UI/ButtonContainer/HBoxContainer2/Steal".disabled = false
	
	if $"../Player".CP >= 2:
		zero_cp_action = [0,1,3]
		less_cp_acton = [0,1,2,3]
		max_cp_action = [0,1,2,3,4,5]
		if CP == 0:
			action_code = zero_cp_action[randi() % zero_cp_action.size()]
		elif CP < 3 and CP > 0:
			action_code = less_cp_acton[randi() % less_cp_acton.size()]
		elif CP == 3:
			action_code = max_cp_action[randi() % max_cp_action.size()]
	elif $"../Player".CP < 2:
		zero_cp_action = [1,3]
		less_cp_acton = [1,2,3]
		max_cp_action = [1,2,3,4,5]
		if CP == 0:
			action_code = zero_cp_action[randi() % zero_cp_action.size()]
		elif CP < 3 and CP > 0:
			action_code = less_cp_acton[randi() % less_cp_acton.size()]
		elif CP == 3:
			action_code = max_cp_action[randi() % max_cp_action.size()]
	

func _on_finish_pressed():
	var user = get_node('.')
	var target = get_node('../Player')
	var info: Array = [user, target, action_code]
	emit_signal('aif',info)
	
	

