class_name MiniGameLastDose
extends BaseGame


@onready var player_01__ref: HBoxContainer = $Player_01

@onready var player_02__ref: HBoxContainer = $Player_02


func _ready() -> void: self.__onReady__()


func on_GameControlOverlay_story_finished() -> void:
    if self.player_side == 1:
        self.player_01__ref.show()
        self.player_02__ref.hide()
    else:
        self.player_01__ref.hide()
        self.player_02__ref.show()

func on_choice_1_selected():
    self.disableChoiceButtons()
    self.game_control_overlay__ref.stopTimerAndShowChoiceRecorded()
    save_manager.save.choice_dict[self.player_code] = 1
    await get_tree().create_timer(3).timeout
    self.main_game__ref.requestCloseCurrentGame()

func on_choice_2_selected():
    self.disableChoiceButtons()
    self.game_control_overlay__ref.stopTimerAndShowChoiceRecorded()
    save_manager.save.choice_dict[self.player_code] = 2
    await get_tree().create_timer(3).timeout
    self.main_game__ref.requestCloseCurrentGame()

func on_no_choice_was_made():
    self.disableChoiceButtons()
    save_manager.save.choice_dict[self.player_code] = 0
    await get_tree().create_timer(3).timeout
    self.main_game__ref.requestCloseCurrentGame()

func disableChoiceButtons():
    for button in get_tree().get_nodes_in_group("choice_buttons"): if button is Button:
        button.disabled = true

func postInit():
    self.game_control_overlay__ref.postInit(self.player_side) # Load stories to show, etc.

func __onReady__():
    self.player_01__ref.hide()
    self.player_02__ref.hide()

static func getGameResult(player_01_choice: int, player_02_choice: int) -> String:
    # P1: Give Engineer; Give Themselves and Escape
    # P2: Keep fixing; Escape
    var match_code := player_01_choice * 10 + player_02_choice
    match match_code:
        00: return str(
            "The ship explodes and no one was alive. ",
            "But, there is a sealed medicine box,",
            " floating with the relic of the explosion."
        )

        01: return str(
            "The ship was safe. ",
            "The engineer and the doctor are praised as hero who sacrified themselves."
        )

        02: return str(
            "The ship explodes and the most staff died. ",
            "An escape hatch was launched before explosion. ",
            "But where would they go ?"
        )

        10: return str(
            "The ship explodes and no one was alive. ",
            "Nobody knows what happened in that ship."
        )

        11: return str(
            "The ship was safe. ",
            "The doctor is praised as hero who sacrified themselves."
        )

        12: return str(
            "The ship explodes and the most staff died. ",
            "An escape hatch was launched before explosion. ",
            "But where would they go ?"
        )

        20: return str(
            "The ship explodes and the most staff died. ",
            "An escape hatch was launched before explosion. ",
            "But where would they go ?"
        )

        21: return str(
            "The ship was safe. ",
            "The engineer is praised as hero who sacrified themselves. ",
            "But an escape hatch was launched."
        )

        22: return str(
            "The ship explodes and the most staff died. ",
            "Two escape hatches were launched before explosion. ",
            "But where would they go ?"
        )

        _:
            printerr("Should not have this result `", match_code, "`.")
            return ""
