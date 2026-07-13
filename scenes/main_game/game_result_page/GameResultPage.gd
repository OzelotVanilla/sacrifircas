class_name GameResultPage
extends Control


@onready var restart_game_button__ref: Button = $VBox/HBox/RestartGameButton

@onready var label__ref: Label = $VBox/Margin/Scroll/Label


var result_cache: String


func _ready() -> void: self.__onReady__()


func copyCacheToClipboard():
    if OS.has_feature("web"):
        var js_code := str(
            """
            navigator.clipboard.writeText(
            """,
            JSON.stringify(self.result_cache), # Already has double quote around.
            """
            )
            """
        )
        JavaScriptBridge.eval(js_code)
    else:
        DisplayServer.clipboard_set(self.result_cache)

func refreshResultDisplay():
    self.label__ref.text = self.result_cache

func getResultFromSave() -> String:
    var game_results := PackedStringArray()

    ## [code]{game_id_with_variation: true}[/code]
    var finished_game: Dictionary = \
        save_manager.save.choice_dict.keys().reduce(
            func(dict: Dictionary, value: String):
                dict[value.rsplit("_", false, 1)[0]] = true
                return dict,
            {}
        )
    for game in finished_game:
        var player_1_key := str(game, "_1")
        var player_2_key := str(game, "_2")
        var player_3_key := str(game, "_3")
        if not save_manager.save.choice_dict.has(player_1_key) \
            or not save_manager.save.choice_dict.has(player_2_key):
                continue

        var player_1_choice := save_manager.save.choice_dict[player_1_key]
        var player_2_choice := save_manager.save.choice_dict[player_2_key]
        var player_3_choice: int
        var game_result: String = "No Game Result"

        # 3-players game.
        if save_manager.save.choice_dict.has(player_3_key):
            player_3_key = str(game, "_3")
            player_3_choice = save_manager.save.choice_dict[player_3_key]
        # 2-players game.
        else:
            match game.split("_", false)[0]:
                "ld":
                    game_result = str(
                        game, ":\n",
                        MiniGameLastDose.getGameResult(
                            player_1_choice, player_2_choice
                        )
                    )

        game_results.push_back(game_result)

    return "\n\n".join(game_results)

func on_RestartGameButton_pressed() -> void:
    save_manager.createSave()
    get_tree().change_scene_to_file(
        "res://scenes/main_game/MainGame.tscn"
    )

func __onReady__():
    var result := self.getResultFromSave()
    if result.is_empty():
        self.result_cache = "No game result to show here..."
    else:
        self.result_cache = result

    self.copyCacheToClipboard()
    self.refreshResultDisplay()
