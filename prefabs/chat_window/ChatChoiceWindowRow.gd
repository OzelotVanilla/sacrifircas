class_name ChatChoiceWindowRow
extends HBoxContainer
## UI node of chat's choice window's option row


@onready var right_arrow__ref: TextureRect = $RightArrow

@onready var label__ref: Label = $Label


## Text to be showed in option row of [ChatOverlay].
## Do not directly set value in inspector, since export was test purpose only.
@export_multiline var text: String = "":
    set(value):
        if text != value:
            text = value
            if not self.is_node_ready():
                await self.ready
            self.label__ref.text = value

## The value of this choice.
## Will be emitted by [signal ChatChoiceWindow.choice_selected]
@export var value: String = ""

var choice_window__ref: ChatChoiceWindow

var index_in_choice_window: int


func _ready() -> void: self.__onReady__()


func on_focus_entered():
    self.showArrow()
    self.choice_window__ref.current_selected_index = self.index_in_choice_window

func on_focus_exited():
    self.hideArrow()

func __onReady__():
    self.hideArrow()

func showArrow():
    self.right_arrow__ref.self_modulate.a = 1

func hideArrow():
    self.right_arrow__ref.self_modulate.a = 0
