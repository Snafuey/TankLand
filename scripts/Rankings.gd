extends Control

signal start_new_round()

onready var colorRectLeft = $CenterContainer/UIPanel/ColorRectLeft
onready var colorRectRight = $CenterContainer/UIPanel/ColorRectRight
onready var rankLines = $CenterContainer/UIPanel/RankLines
onready var roundsRemaining = $CenterContainer/UIPanel/RoundsRemaining

var player_ranks: Array = []

func _ready() -> void:
	init_rankings()

func _on_OkButton_pressed() -> void:
	var battleField = get_parent()
	connect("start_new_round", battleField, "set_new_round") # warning-ignore:return_value_discarded
	emit_signal("start_new_round")
	self.queue_free()

func init_rankings() -> void:
	yield(get_tree(), "idle_frame")
	build_ranks("Earnings")
	set_banner_color()
	hide_lines_unused()
	set_rank_data()
	set_remaining_rounds()

func build_ranks(type: String) -> void:
	player_ranks = GameData.build_ranks_by_type(type)

func set_banner_color() -> void:
	colorRectLeft.color = GameData.player_data[player_ranks[0][1]]["Color"]
	colorRectRight.color = colorRectLeft.color

func hide_lines_unused() -> void:
	var hide_total = 7 - GameData.game_settings["Players"]
	var hide_index = (7 - hide_total) - 1
	var rankLine = rankLines.get_children()
	for i in hide_total:
		hide_index += 1
		rankLine[hide_index].visible = false

func set_rank_data() -> void:
	var total_players: int = GameData.game_settings["Players"]
	for i in total_players:
			var lineStats = get_node("CenterContainer/UIPanel/RankLines/" + str(i + 1)).get_children()
			for j in lineStats.size():
				var stat = lineStats[j]
				match j:
					0:
						pass
					1:
						stat.text = GameData.player_data[player_ranks[i][1]]["Name"]
					2:
						stat.text = str(GameData.player_data[player_ranks[i][1]]["Kills"])
					3:
						stat.text = "$" + str(GameData.player_data[player_ranks[i][1]]["Earnings"])

func set_remaining_rounds() -> void:
	var battleField = get_parent()
	var current_round = battleField.current_round
	var remaining_rounds = GameData.game_settings["Rounds"] - current_round
	if remaining_rounds == 1:
		roundsRemaining.text = str(remaining_rounds) + " round remains."
	else:
		roundsRemaining.text = str(remaining_rounds) + " rounds remain."
