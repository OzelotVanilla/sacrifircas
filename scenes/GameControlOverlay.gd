class_name GameControlOverlay
extends Control
## Overlay of each mini game and control logic
##
## Should be directly included as the child.


## Emit when [ChatOverlay] finishes displaying stories.
signal story_finished()

## Emit when the timer runs out of time.
signal choose_timeout()


@onready var chat_overlay__ref: ChatOverlay = $ChatOverlay

@onready var time_remain_bar__ref: TimeRemainBar = $TimeRemainBar


## Will be showed in [ChatOverlay],
##  along with [member side_1_story] or [member side_2_story].
@export_multiline var story: String

@export_multiline var side_1_story: String

@export_multiline var side_2_story: String


func _ready() -> void: self.__onReady__()


func on_ChatOverlay_finished() -> void:
    self.chat_overlay__ref.hide()
    self.time_remain_bar__ref.show()
    self.time_remain_bar__ref.start()
    self.story_finished.emit()

func on_TimeRemainBar_timeout() -> void:
    self.choose_timeout.emit()

## Called when player made a choice.
func stopTimerAndShowChoiceRecorded():
    self.time_remain_bar__ref.stopCountingAndShowChoiceRecorded()

func postInit(player_side: int):
    self.chat_overlay__ref.show()
    self.chat_overlay__ref.startStoryAndChoiceProcess(str(
        self.story, "\n",
        self.side_1_story if player_side == 1 else self.side_2_story
    ))
    self.chat_overlay__ref.grab_focus()

func __onReady__():
    self.time_remain_bar__ref.hide()
