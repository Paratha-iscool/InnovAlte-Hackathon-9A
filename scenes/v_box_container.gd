extends VBoxContainer

# UI Elements (Connect these in the Godot editor)
@onready var task_input = $HBoxContainer/TaskInput
@onready var add_button = $HBoxContainer/AddButton
@onready var task_list = $TaskList

# Task Data
var tasks = []

func _ready():
	add_button.connect("pressed", _on_add_button_pressed)

func _on_add_button_pressed():
	var task_text = task_input.text.strip_edges()
	if task_text.is_empty():
		return # Don't add empty tasks

	tasks.append({"text": task_text, "completed": false})
	task_input.clear()
	_update_task_list()

func _update_task_list():
	# Clear the existing list
	for child in task_list.get_children():
		child.queue_free()

	# Re-populate the list
	for i in range(tasks.size()):
		var task = tasks[i]
		var task_row = HBoxContainer.new()
		task_list.add_child(task_row)

		var checkbox = CheckBox.new()
		checkbox.button_pressed = task.completed
		checkbox.connect("toggled", _on_task_toggled.bind(i))
		task_row.add_child(checkbox)

		var label = Label.new()
		label.text = task.text
		label.add_theme_color_override("font_color", Color("Red"))  
		if task.completed:
			label.add_theme_color_override("font_color", Color("Blue"))  
		task_row.add_child(label)

		var delete_button = Button.new()
		delete_button.text = "X"
		delete_button.connect("pressed", _on_delete_task.bind(i))
		task_row.add_child(delete_button)

func _on_task_toggled(completed, task_index):
	tasks[task_index].completed = completed
	_update_task_list()

func _on_delete_task(task_index):
	tasks.remove_at(task_index)
	_update_task_list()
