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
    self.game_control_overlay__ref.stopTimerAndShowChoiceRecorded()
    save_manager.save.choice_dict[self.player_code] = 1
    await get_tree().create_timer(3).timeout
    self.main_game__ref.requestCloseCurrentGame()

func on_choice_2_selected():
    self.game_control_overlay__ref.stopTimerAndShowChoiceRecorded()
    save_manager.save.choice_dict[self.player_code] = 2
    await get_tree().create_timer(3).timeout
    self.main_game__ref.requestCloseCurrentGame()

func on_no_choice_was_made():
    save_manager.save.choice_dict[self.player_code] = 0
    await get_tree().create_timer(3).timeout
    self.main_game__ref.requestCloseCurrentGame()

func postInit():
    self.game_control_overlay__ref.postInit() # Load stories to show, etc.

func __onReady__():
    self.player_01__ref.hide()
    self.player_02__ref.hide()
