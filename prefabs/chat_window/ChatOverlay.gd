class_name ChatOverlay
extends Control
## UI overlay node to show chat and choices
##
## TODO: This class is currently also acted as the holder of dialog runner.
##       Should move the logic about node switching and chat process to somewhere else
##        in the future.


## When all text and choice finishes.
signal finished()


@onready var chat_text_window__ref: ChatTextWindow = $Margin/VBox/ChatTextWindow

@onready var chat_choice_window__ref: ChatChoiceWindow = $Margin/VBox/ChatChoiceWindow


var text_being_displayed__cache: String


func _ready() -> void: self.__onReady__()


func startStoryAndChoiceProcess(text: String):
    self.chat_choice_window__ref.hide()

    self.chat_text_window__ref.show()
    self.chat_text_window__ref.text = text
    self.text_being_displayed__cache = text
    self.chat_text_window__ref.grab_focus()

func showWhetherReadAgainChoice():
    self.chat_choice_window__ref.clear()
    self.chat_choice_window__ref.addOption("Read Again", "again")
    self.chat_choice_window__ref.addOption("Proceed", "ok")
    self.chat_choice_window__ref.addNeighbourSettingAndIndexToOptions()
    self.chat_choice_window__ref.appear()

func on_ChatChoiceWindow_choice_selected(choice_value: String):
    match choice_value:
        "again":
            self.startStoryAndChoiceProcess(self.text_being_displayed__cache)

        "ok":
            self.finished.emit()

func on_ChatTextWindow_finished() -> void:
    self.showWhetherReadAgainChoice()

func on_focus_entered() -> void:
    if self.chat_choice_window__ref.is_visible_in_tree():
        self.chat_choice_window__ref.grab_focus()
    else:
        self.chat_text_window__ref.grab_focus()

func __onReady__():
    pass
