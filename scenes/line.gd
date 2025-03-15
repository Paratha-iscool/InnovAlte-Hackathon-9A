extends Control

@export var textbox_scene: PackedScene  # Assign a TextBox scene in the editor

var line_position: float
var holding_time: float = 0.0
var is_holding: bool = false

@onready var scroll_container = $ScrollContainer
@onready var vbox = $ScrollContainer/VBoxContainer
@onready var timer = $Timer

func _ready():
	line_position = get_viewport_rect().size.x / 2  # Center the line
	timer.wait_time = 3.0  # Set hold time to 3 seconds
	timer.one_shot = true
	queue_redraw()  # Ensure the line is drawn on start

func _process(delta):
	queue_redraw()  # Ensure the line keeps being redrawn
	if is_holding:
		holding_time += delta
		if holding_time >= 3.0:
			add_textbox(get_local_mouse_position().y)
			holding_time = 0.0
			is_holding = false

func _draw():
	draw_line(Vector2(line_position, 0), Vector2(line_position, get_viewport_rect().size.y), Color.BLUE, 2.0)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and abs(event.position.x - line_position) <= 5:
			is_holding = true
			timer.start()
		else:
			is_holding = false
			holding_time = 0.0

func add_textbox(y_position: float):
	var textbox = textbox_scene.instantiate()
	textbox.size_flags_horizontal = Control.SIZE_FILL
	textbox.custom_minimum_size.y = 50  # Minimum height for visibility
	vbox.add_child(textbox)
	vbox.move_child(textbox, vbox.get_child_count() - 1)
	scroll_container.ensure_control_visible(textbox)
