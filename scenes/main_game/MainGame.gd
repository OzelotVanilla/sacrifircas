class_name MainGame
extends Control


var last_dose__scene := preload(
    "res://scenes/last_dose/MiniGameLastDose.tscn"
)


@onready var game_container__ref: Control = $GameContainer

@onready var menu_ui_vbox__ref: VBoxContainer = $MenuUIVBox

@onready var line_edit__ref: LineEdit = $MenuUIVBox/LineEdit


func _ready() -> void: self.__onReady__()


func on_LineEdit_text_submitted(player_code: String) -> void:
    if player_code.count("_") != 2:
        await self.showLineEditErrorInput(
            str("Invalid player code")
            #str("Invalid player code `", player_code, "`.")
        )
        return

    var player_code_destruct := player_code.split("_", false, 3)
    var level_name      := player_code_destruct[0]
    var level_variation := int(player_code_destruct[1])
    var player_side     := int(player_code_destruct[2])
    var scene_to_load: PackedScene
    match level_name:
        "ld":
            scene_to_load = last_dose__scene

        _:
            await self.showLineEditErrorInput(
                str("Invalid player code")
                #str("No level is called `", level_name, "`.")
            )
            return

    self.changeToGame(scene_to_load, level_variation, player_side, player_code)

func showLineEditErrorInput(error: String):
    self.line_edit__ref.text = error
    self.line_edit__ref.editable = false
    await get_tree().create_timer(2).timeout
    self.line_edit__ref.clear()
    self.line_edit__ref.editable = true
    self.line_edit__ref.edit()

func on_FinishAndStatButton_pressed() -> void:
    get_tree().change_scene_to_file(
        "res://scenes/main_game/game_result_page/GameResultPage.tscn"
    )

func changeToGame(
    scene: PackedScene, level_variation: int, player_side: int,
    player_code: String
):
    self.requestCloseCurrentGame()

    self.game_container__ref.show()
    self.menu_ui_vbox__ref.hide()

    var game: BaseGame = scene.instantiate()
    self.game_container__ref.add_child(game)
    game.level_variation = level_variation
    game.player_side     = player_side
    game.player_code     = player_code
    game.main_game__ref  = self
    game.postInit()

func requestCloseCurrentGame():
    for game in self.game_container__ref.get_children():
        self.game_container__ref.remove_child(game)
        game.queue_free()

    self.game_container__ref.hide()
    self.menu_ui_vbox__ref.show()
    self.line_edit__ref.clear()
    self.line_edit__ref.grab_focus.call_deferred()

func __onReady__():
    save_manager.createSave()
    self.line_edit__ref.grab_focus()
