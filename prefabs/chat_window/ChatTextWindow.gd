class_name ChatTextWindow
extends PanelContainer
## Text window of [ChatOverlay]
##
## Will show a down arrow when the text is going to finish.


## Emitted when the showing of text is finished.
signal finished()


@onready var label__ref: Label = $Margin/Label

@onready var down_arrow__ref: TextureRect = $DownArrow


## Text to be showed in the text window of [ChatOverlay].
## Do not directly set value in inspector, since export was test purpose only.
var text: String = "":
    set = setText

## The line index of the first line of current showing text.
var current_line_index: int = 0:
    set = setCurrentLineIndex

## Checks if there are still text to show.
## Useful for checking if need to show and move focus to choice window.
var has_remaining_text_to_show: bool:
    get():
        return self.label__ref.get_line_count() - self.label__ref.lines_skipped > 2

## Become false when need to focus to option window.
var is_primary_focused: bool = true


func _unhandled_input(event: InputEvent) -> void: self.__onUnhandledInput__(event)


func setText(value: String) -> void:
    text = value
    if not self.is_node_ready():
        await self.ready

    # # Set text.
    self.label__ref.text = value

    # # Reset all internal status.
    self.resetReadProgress()

    var line_count := self.label__ref.get_line_count()
    if line_count <= 1:
        self.label__ref.text += "\n".repeat(2 - line_count)
        self.down_arrow__ref.show() # In this situation, the chat is going to over.

func setCurrentLineIndex(value: int) -> void:
    current_line_index = value
    if not self.is_node_ready():
        await self.ready

    # # Set label property.
    self.label__ref.lines_skipped = value

    # # Down arrow.
    self.adjustVisibilityOfDownArrow()

func resetReadProgress():
    self.current_line_index = 0

## See if need to show down arrow.
## If the remaining text has less or equal to 2 lines, show down arrow.
func adjustVisibilityOfDownArrow():
    if self.has_remaining_text_to_show:
        self.down_arrow__ref.hide()
    else:
        self.down_arrow__ref.show()

func __onUnhandledInput__(event: InputEvent) -> void:
    if event.is_action_pressed("ui_accept") and self.is_primary_focused:
        self.on_input__ui_accept()
        get_viewport().set_input_as_handled()

func on_input__ui_accept():
    # If there is still text to show, just go to next line.
    if self.has_remaining_text_to_show:
        self.current_line_index += 1
    # If the remaining text has less or equal to 2 lines, send `finished` signal.
    else:
        self.finished.emit()
