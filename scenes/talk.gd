extends Node2D

var python_script_path = "res://gemini_query.py" # Adjust if needed
var api_key = "AIzaSyCQ5sslSSzED7friNAeS4kut7wnmqLFqHY" # Replace with your API key

@onready var line_edit = $LineEdit
@onready var label = $Label
@onready var ask_button = $AskButton

func _ready():
	ask_button.connect("pressed", Callable(self, "_on_ask_button_pressed"))

func _on_ask_button_pressed():
	var question = line_edit.text
	if !question.is_empty():
		query_gemini(question)
	else:
		label.text = "Please enter a question."

func query_gemini(prompt):
	var args = ["python", python_script_path, api_key, prompt]
	var output = PackedStringArray() # Corrected line
	var err = OS.execute(args[0], args.slice(1), output)
	print("thingamajig")

	if err != 0:
		print("Error executing Python script:", err)
		label.text = "Error executing Python script."
		return

	var output_text = output.join("\n") # Corrected line
	label.text = output_text
