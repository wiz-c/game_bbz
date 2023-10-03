extends Node2D

var CP: int = 0
var LP: int = 1
var CP_max: int = 3
var LP_max: int = 1

var action_code: int = 1
signal aif
var zero_cp_action: Array[int] = [0,1,3]
var less_cp_acton: Array[int] = [0,1,2,3]
var max_cp_action: Array[int] = [0,1,2,3,4,5]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(_delta):
	var cp_text: String = 'CP: %d / %d' % [CP, CP_max]
	var lp_text: String = 'LP: %d / %d' % [LP, LP_max]
	$Char_State/State/LP/Label.text = lp_text
	$Char_State/State/CP/Label.text = cp_text
	$Char_State/State/LP.max_value = LP_max
	$Char_State/State/LP.value = LP
	$Char_State/State/CP.max_value = CP_max
	$Char_State/State/CP.value = CP
	if $"../Player".CP < 1:
		$"../UI/ButtonContainer/HBoxContainer/Hit".disabled = true
		$"../UI/ButtonContainer/HBoxContainer2/S_Hit".disabled = true
		$"../UI/ButtonContainer/HBoxContainer2/S_Defense".disabled = true
	elif $"../Player".CP < 3:
		$"../UI/ButtonContainer/HBoxContainer/Hit".disabled = false
		$"../UI/ButtonContainer/HBoxContainer2/S_Hit".disabled = true
		$"../UI/ButtonContainer/HBoxContainer2/S_Defense".disabled = true
	elif $"../Player".CP == 3:
		$"../UI/ButtonContainer/HBoxContainer/Hit".disabled = false
		$"../UI/ButtonContainer/HBoxContainer2/S_Hit".disabled = false
		$"../UI/ButtonContainer/HBoxContainer2/S_Defense".disabled = false
'''
	if CP == 0:
		action_code = zero_cp_action[randi() % zero_cp_action.size()]
	elif CP < 3 and CP > 0:
		action_code = less_cp_acton[randi() % less_cp_acton.size()]
	elif CP == 3:
		action_code = max_cp_action[randi() % max_cp_action.size()]
'''

func _on_finish_pressed():
	var user = get_node('.')
	var target = get_node('../Enemy')
	var info: Array = [user, target, action_code]
	# print('player_done')
	emit_signal('aif',info)

	
	
func _on_hit_pressed():
	action_code = 2 

func _on_charge_pressed():
	action_code = 1

func _on_defense_pressed():
	action_code = 3

func _on_s_hit_pressed():
	action_code = 4

func _on_steal_pressed():
	action_code = 0

func _on_s_defense_pressed():
	action_code = 5
