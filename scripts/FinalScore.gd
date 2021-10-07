extends Control

const MAIN_MENU:String = "res://scenes/menus/MainMenu.tscn"
const BATTLE_FIELD:String = "res://scenes/level/BattleField.tscn"

onready var rankLines = $CenterContainer/UIPanel/RankLines
onready var sortOptions = $CenterContainer/UIPanel/SortOptions
onready var sceneManager = find_parent("GameMain")

var player_ranks: Array = []
var sort_is_total: bool = true

func _ready() -> void:
	init_scores()


func _on_NewGameButton_pressed() -> void:
	GameData.new_game_clear_data()
	sceneManager.transition_scene(MAIN_MENU)

func _on_ReplayButton_pressed() -> void:
	GameData.restart_game_clear_data()
	sceneManager.transition_scene(BATTLE_FIELD)

func _on_QuitButton_pressed() -> void:
	get_tree().quit()

func _on_SortOptions_item_selected(index: int) -> void:
	player_ranks.clear()
	match index:
		0:
			sort_is_total = true
			build_ranks("Earnings")
			set_rank_data()
		1:
			sort_is_total = true
			build_ranks("TotalKills")
			set_rank_data()
		2:
			sort_is_total = false
			build_ranks("Kills")
			set_rank_data()

func init_scores() -> void:
	yield(get_tree(),"idle_frame")
	add_sort_items()
	hide_lines_unused()
	build_ranks("Earnings")
	set_rank_data()

func add_sort_items() -> void:
	sortOptions.add_item(" Earnings")
	sortOptions.add_item(" Kills")
	sortOptions.add_item(" Last Round")

func hide_lines_unused() -> void:
	var hide_total = 7 - GameData.game_settings["Players"]
	var hide_index = (7 - hide_total) - 1
	var rankLine = rankLines.get_children()
	for i in hide_total:
		hide_index += 1
		rankLine[hide_index].visible = false

func build_ranks(type: String) -> void:
	player_ranks = GameData.build_ranks_by_type(type)

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
						if sort_is_total:
							stat.text = str(GameData.player_data[player_ranks[i][1]]["TotalKills"])
						else:
							stat.text = str(GameData.player_data[player_ranks[i][1]]["Kills"])
					3:
						stat.text = "$" + str(GameData.player_data[player_ranks[i][1]]["Earnings"])
