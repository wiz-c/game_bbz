extends Node2D

var player_info: Array
var enemy_info: Array
var turns_count: int = 0

var stage: bool = 0
var label_str: String = 'Remain Turns: %d / 12' % turns_count
signal res_out

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../UI/Label".text = label_str
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if stage == true:
		battle_handle(player_info, enemy_info)
	$"../UI/Label".text = 'Remain Turns: %d / 12' % turns_count
	
	
func _on_player_aif(info):
	player_info = info

func _on_enemy_aif(info):
	enemy_info = info
	stage = 1


func consume_cp(user: Node, target: Node, action_code: int):
	match action_code:
		1:
			if user.CP <3:
				user.CP += 1
		2:
			user.CP -= 1
		4:
			user.CP -= 3
		5:	
			user.CP -= 2
		_:
			pass
			
func choose_action(player_info, enemy_info):
	var s: Array = [0]
	var a: Array = [2, 4]
	var d: Array = [1, 3, 5]
	
	if player_info[2] in s:
		if enemy_info[2] in s:
			return 'draw\n'
		elif enemy_info[2] in d:
			take_cp_damage(player_info[0], player_info[1], player_info[2])
			return 'player steal 1 CP from enemy\n'
		elif enemy_info[2] in a:
			take_lp_damage(enemy_info[0],enemy_info[1], enemy_info[2])
			return 'enemy hit player, cause 1 damage\n'
	
	if player_info[2] in a:
		if enemy_info[2] in s:
			take_lp_damage(player_info[0], player_info[1], player_info[2])
			return 'player hit enemy, cause 1 LP damgae\n'
		elif enemy_info[2] in a:
			if player_info[2] > enemy_info[2]:
				take_lp_damage(player_info[0], player_info[1], player_info[2])
				return "player break enemy's hit, cause 1 LP damgae\n"
			elif player_info[2] < enemy_info[2]:
				take_lp_damage(enemy_info[0],enemy_info[1], enemy_info[2])
				return "enemy break player's hit, cause 1 LP damage\n"
			elif  player_info[2] == enemy_info[2]:
				return "draw\n"
		elif enemy_info[2] in d:
			if player_info[2] > enemy_info[2]:
				take_lp_damage(player_info[0], player_info[1], player_info[2])
				return "player break enemy's defense, cause 1 LP damage\n"
			elif player_info[2] < enemy_info[2]:
				return "enemy defense success\n"
	
	if player_info[2] in d:
		if enemy_info[2] in s:
			take_cp_damage(enemy_info[0],enemy_info[1], enemy_info[2])
			return 'enemy steal 1 CP from player\n'
		elif enemy_info[2] in a:
			if player_info[2] > enemy_info[2]:
				return "player defense success\n"
			elif player_info[2] < enemy_info[2]:
				take_lp_damage(enemy_info[0],enemy_info[1], enemy_info[2])
				return "enemy break player's defense, cause 1 damage\n"
		elif enemy_info[2] in d:
			return "draw\n"
			

func take_lp_damage(user, target, action_code):
	match action_code:
		2:
			target.LP -= 1
		4:
			target.LP -= 1
		_:
			pass

func take_cp_damage(user, target, action_code):
	match action_code:
		0:
			if target.CP >= 1:
				target.CP -= 1
				if user.CP <3:
					user.CP += 1
		_:
			pass
	
func reset_game_state(player_info, enemy_info):
	player_info[0].LP = player_info[0].LP_max
	player_info[0].CP = 0
	player_info[0].action_code = 1
	enemy_info[0].LP = enemy_info[0].LP_max
	enemy_info[0].CP = 0
	turns_count = 0
	$"../UI/PanelContainer/RichTextLabel".clear()
	return "Another Trun Begin!\n"
	
func action_code_to_name(action_code: int):
	match action_code:
		0:
			return 'Steal rival CP'
		1:
			return 'Charge CP'
		2:
			return 'Attack rival'
		3:
			return "Defense rival's attack"
		4:
			return "Attck rival with full power"
		5:
			return "Defense rival's attack with full power"
	

func battle_handle(player_info, enemy_info):
	var output: String

	consume_cp(player_info[0], player_info[1], player_info[2])
	consume_cp(enemy_info[0], enemy_info[1], enemy_info[2])
	
	output = "player decide %s, enemy decide %s\n" % [action_code_to_name(player_info[2]), action_code_to_name(enemy_info[2])]

	output += "Result is: " + choose_action(player_info, enemy_info)
	if player_info[0].LP <= 0: 
		output += "\nEnemy win!\n________________________\n"
		output += reset_game_state(player_info, enemy_info)
	elif enemy_info[0].LP <= 0:
		output += "\nPlayer win!\n________________________\n"
		output += reset_game_state(player_info, enemy_info)
	elif turns_count >= 12:
		output += "\nThis game is TOO LONG!\n ________________________\n"
		output += reset_game_state(player_info, enemy_info)
	emit_signal("res_out", output)
	
	turns_count += 1
	stage = 0


