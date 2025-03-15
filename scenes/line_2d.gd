extends Line2D

# Load the button and textedit scenes.
var button_scene = preload("res://scenes/button_scene.tscn")
var textedit_scene = preload("res://scenes/textedit_scene.tscn")

# Spacing between buttons in pixels.
var button_spacing = 4
# Scroll speed of the line.
var scroll_speed = 100

# Canvas layer for text boxes.
var text_layer = CanvasLayer.new()

func _ready():
	# Add the text layer.
	add_child(text_layer)
	# Create the buttons.
	create_buttons()

func _process(delta):
	# Scroll the line upwards.
	position.y -= scroll_speed * delta

	# Scroll the buttons along with the line.
	for child in get_children():
		if child is Button:
			child.position.y -= scroll_speed * delta

	# Reset line position when off-screen.
	if position.y < -get_viewport_rect().size.y:
		position.y = get_viewport_rect().size.y

func create_buttons():
	# Calculate the total length of the line.
	var line_length = 0
	for i in range(get_point_count() - 1):
		line_length += get_point_position(i).distance_to(get_point_position(i + 1))

	# Calculate the number of buttons needed.
	var num_buttons = int(line_length / button_spacing)

	for i in range(num_buttons):
		# Calculate the button's position along the line.
		var button_position = calculate_position_along_line(i * button_spacing)

		# Create a button instance.
		var button_instance = button_scene.instantiate()
		button_instance.position = button_position
		add_child(button_instance)

		# Connect the button's pressed signal.
		button_instance.pressed.connect(func(): on_button_pressed(button_position))

func calculate_position_along_line(distance):
	var current_distance = 0
	for i in range(get_point_count() - 1):
		var segment_length = get_point_position(i).distance_to(get_point_position(i + 1))
		if current_distance + segment_length >= distance:
			var remaining_distance = distance - current_distance
			var ratio = remaining_distance / segment_length
			return get_point_position(i).lerp(get_point_position(i + 1), ratio)
		current_distance += segment_length
	return get_point_position(get_point_count() - 1)

func on_button_pressed(button_position):
	# Create the textedit instance and add it to the text layer.
	var textedit_instance = textedit_scene.instantiate()
	text_layer.add_child(textedit_instance)
	#place textedit at button position.
	textedit_instance.position = button_position
