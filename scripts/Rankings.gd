extends Control

onready var colorRectLeft = $CenterContainer/UIPanel/ColorRectLeft
onready var colorRectRight = $CenterContainer/UIPanel/ColorRectRight
onready var rankLines = $CenterContainer/UIPanel/RankLines
onready var roundsRemaining = $CenterContainer/UIPanel/RoundsRemaining

var player_ranks: Array = []

func _ready() -> void:
	init_rankings()

func _on_OkButton_pressed() -> void:
	Events.emit_signal("change_game_state", GameData.GAME_STATES.BATTLE)
	self.queue_free()

func init_rankings() -> void:
	build_ranks("Earnings")
	set_banner_color()
	hide_lines_unused()
	set_rank_data()
	set_rounds()

func build_ranks(type: String) -> void:
	player_ranks = Utils.get_stats_by_type(type)
	player_ranks.sort_custom(Utils, "sort_decending")

func set_banner_color() -> void:
	colorRectLeft.color = Utils.get_player_color(player_ranks[0][1])
#	colorRectLeft.color = GameData.tank_data[player_ranks[0][1]]["Color"]
	colorRectRight.color = colorRectLeft.color

func hide_lines_unused() -> void:
	var hide_total = 7 - Utils.get_total_tank_number()
	var hide_index = (7 - hide_total) - 1
	var rankLine = rankLines.get_children()
	for i in hide_total:
		hide_index += 1
		rankLine[hide_index].visible = false

func set_rank_data() -> void:
	var total_players: int = Utils.get_total_tank_number()
	for i in total_players:
			var lineStats = get_node("CenterContainer/UIPanel/RankLines/" + str(i + 1)).get_children()
			for j in lineStats.size():
				var stat = lineStats[j]
				match j:
					0:
						pass
					1:
						stat.text = Utils.get_player_name(player_ranks[i][1])
						#GameData.tank_data[player_ranks[i][1]]["Name"]
					2:
						stat.text = str(Utils.get_player_kills(player_ranks[i][1]))
						#str(GameData.tank_data[player_ranks[i][1]]["Kills"])
					3:
						stat.text = "$" + str(Utils.get_player_earnings(player_ranks[i][1]))
						#str(GameData.tank_data[player_ranks[i][1]]["Earnings"])

func set_rounds() -> void:
	var battleMain: Node = get_parent().get_node_or_null("BattleField")
	if battleMain:
		var rounds_left = Utils.get_remaining_rounds(battleMain.current_round)
		if rounds_left == 1:
			roundsRemaining.text = str(rounds_left) + " round remains."
		else:
			roundsRemaining.text = str(rounds_left) + " rounds remain."
