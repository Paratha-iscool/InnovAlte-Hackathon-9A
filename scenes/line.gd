extends Control

var line_width = 2
var line_color = Color.SKY_BLUE
var textbox_spacing = 5

var line_position = Vector2(0, 0)
var textboxes = []
var held_position = Vector2.ZERO
var hold_timer = 0.0
var hold_duration = 3.0
var holding = false

func _ready():
	line_position.x = get_viewport_rect().size.x / 2
	line_position.y = 0

func _draw():
	draw_line(Vector2(line_position.x, 0), Vector2(line_position.x, get_viewport_rect().size.y), line_color, line_width)

func _process(delta):
	if holding:
		hold_timer += delta
		if hold_timer >= hold_duration:
			holding = false
			hold_timer = 0.0
			create_textbox(held_position.y)

	queue_redraw()

func _input(event):
	if event is InputEventScreenTouch:
		var touch_pos = event.position
		if event.pressed:
			if abs(touch_pos.x - line_position.x) < line_width / 2:
				holding = true
				held_position = touch_pos
		else:
			holding = false
			hold_timer = 0.0

func create_textbox(y_position):
	var textbox = LineEdit.new()
	add_child(textbox)
	textboxes.append(textbox)

	var textbox_rect = textbox.get_rect()
	textbox.position.x = line_position.x + 10 # Place it to the right of the line
	textbox.position.y = y_position - textbox_rect.size.y / 2 # Center it vertically on the held point

	# Adjust the position of newly created textbox and other textboxes
	recalculate_textbox_positions()

func recalculate_textbox_positions():
	var current_y = 0.0

	# Sort textboxes based on their y position
	textboxes.sort_custom(func(a, b): return a.position.y < b.position.y)

	for textbox in textboxes:
		var textbox_rect = textbox.get_rect()
		textbox.position.y = current_y
		current_y += textbox_rect.size.y + textbox_spacing

func _on_scroll_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			for textbox in textboxes:
				textbox.position.y += 20
			recalculate_textbox_positions()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			for textbox in textboxes:
				textbox.position.y -= 20
			recalculate_textbox_positions()

func _on_viewport_gui_input(event):
	_on_scroll_input(event)
