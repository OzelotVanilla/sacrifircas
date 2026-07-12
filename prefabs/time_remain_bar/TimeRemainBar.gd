class_name TimeRemainBar
extends Control


## Emit when timer timeout.
signal timeout()


@onready var timer__ref: Timer = $Timer

@onready var progress_and_label_vbox__ref: VBoxContainer = $ProgressAndLabelVBox

@onready var label__ref: Label = $ProgressAndLabelVBox/Label

@onready var progress_bar__ref: ProgressBar = $ProgressAndLabelVBox/ProgressBar

@onready var no_choice_made_label__ref: Label = $NoChoiceMadeLabel

@onready var choice_recorded_label__ref: Label = $ChoiceRecordedLabel


@export_custom(PropertyHint.PROPERTY_HINT_NONE, "suffix:s")
var time_to_count: float = 15


## Do not modify it directly.
var bar__fill_stylebox: StyleBoxFlat

var bar__bg_stylebox: StyleBoxFlat


func _ready() -> void: self.__onReady__()
func _process(delta: float) -> void: self.__onProcess__(delta)


## Start counting
func start():
    self.timer__ref.wait_time = time_to_count
    self.timer__ref.start()
    self.progress_bar__ref.min_value = 0
    self.progress_bar__ref.max_value = time_to_count
    self.set_process(true)

func stopCountingAndShowChoiceRecorded():
    self.timer__ref.stop()
    self.progress_and_label_vbox__ref.hide()
    self.no_choice_made_label__ref.hide()
    self.choice_recorded_label__ref.show()

func __onReady__():
    self.set_process(false)
    self.progress_and_label_vbox__ref.show()
    self.no_choice_made_label__ref.hide()
    self.choice_recorded_label__ref.hide()
    self.bar__fill_stylebox = \
        self.progress_bar__ref.get_theme_stylebox("fill").duplicate()
    self.bar__bg_stylebox = \
        self.progress_bar__ref.get_theme_stylebox("background").duplicate()

var last_colour_change_threshold := -1

func __onProcess__(delta: float):
    # # Text and progress update
    var time_left := self.timer__ref.time_left
    self.progress_bar__ref.value = time_left
    if time_left < 2:
        self.label__ref.text = "hurry up..."
    else:
        self.label__ref.text = str(time_left).pad_decimals(1)

    # # Style.
    var colour_change_threshold: int
    if time_left < 2:
        colour_change_threshold = 1
    elif time_left < 6:
        colour_change_threshold = 2
    else:
        colour_change_threshold = 3

    if colour_change_threshold == self.last_colour_change_threshold:
        return
    self.last_colour_change_threshold = colour_change_threshold

    var background_stylebox := \
        self.progress_bar__ref.get_theme_stylebox("background").duplicate()
    var fill_stylebox       := \
        self.progress_bar__ref.get_theme_stylebox("fill").duplicate()
    if colour_change_threshold == 1:
        background_stylebox.bg_color = Color("fdeff2")
        fill_stylebox.bg_color       = Color("e95464")
        self.label__ref.add_theme_color_override("font_color", Color("e95464"))
    elif colour_change_threshold == 2:
        background_stylebox.bg_color = Color("f8f4e6")
        fill_stylebox.bg_color       = Color("f8b500")
        self.label__ref.add_theme_color_override("font_color", Color("f8b500"))

    self.progress_bar__ref.add_theme_stylebox_override("background", background_stylebox)
    self.progress_bar__ref.add_theme_stylebox_override("fill",       fill_stylebox)

func on_Timer_timeout() -> void:
    self.timeout.emit()
    self.set_process(false)

    self.progress_and_label_vbox__ref.hide()
    self.no_choice_made_label__ref.show()
