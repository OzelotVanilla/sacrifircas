@abstract
class_name BaseGame
extends ColorRect
## Base scene script of all mini game in this project
##
## All mini game should extends [BaseGame] and follow this structure:[br]
## * [GameControlOverlay]
## * Game Logic


## When this level is played multiple times,
##  this member will record the count.
## This need to be done in order to avoid player know who is another player.
var level_variation: int:
    get():
        return int(self.player_code.split("_", false)[1])

## Code name of the player.
var player_code: String

## Either side 1 or 2.
var player_side: int

var main_game__ref: MainGame


@onready var game_control_overlay__ref: GameControlOverlay = $GameControlOverlay


@abstract func on_choice_1_selected()

@abstract func on_choice_2_selected()

@abstract func on_no_choice_was_made()

## In order to load stories, etc.
@abstract func postInit() -> void

static func getGameResult(player_01_choice: int, player_02_choice: int) -> String:
    return "Not Impl-ed."
