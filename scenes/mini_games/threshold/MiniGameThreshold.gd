class_name MiniGameThreshold
extends BaseGame


@onready var player_01__ref: HBoxContainer = $Player_01

@onready var player_02__ref: HBoxContainer = $Player_02

@onready var player_03__ref: HBoxContainer = $Player_03


func _ready() -> void: self.__onReady__()


func on_GameControlOverlay_story_finished() -> void:
    if   self.player_side == 1:
        self.player_01__ref.show()
        self.player_02__ref.hide()
        self.player_03__ref.hide()
    elif self.player_side == 2:
        self.player_01__ref.hide()
        self.player_02__ref.show()
        self.player_03__ref.hide()
    else:
        self.player_01__ref.hide()
        self.player_02__ref.hide()
        self.player_03__ref.show()

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
    self.player_03__ref.hide()

static func getGameResultOf3Players(
    player_01_choice: int, player_02_choice: int, player_03_choice: int
) -> String:
    # P1: Go and Die; Escape
    # P2: Go and Die; Escape
    # P3: Go and Die; Escape
    var people_went_inside: int = 0 \
        + (1 if player_01_choice == 1 else 0) \
        + (1 if player_02_choice == 1 else 0) \
        + (1 if player_03_choice == 1 else 0)

    if people_went_inside < 2:
        return str(
            "The factory exploded. No one was alive. ",
            "But there are murmurs spreading that says there are 3 people there,",
            " the explosion should be avoided. ",
            "But who knows ?"
        )
    elif people_went_inside == 2:
        return str(
            "The explosion was stopped. ",
            "The 3 people who were in charge of this thing,",
            " solves the problem, and the sacrified 2 people was praised as hero."
        )
    else: # > 3
        return str(
             "The explosion was stopped. ",
            "The 3 people who was in charge of this thing,",
            " solves the problem, and they were praised as hero. ",
            "However, murmurs spreading that says, only 2 people were needed to stop that. ",
            "But the person spreads the murmurs was not the people",
            " fighting for others life."
        )
