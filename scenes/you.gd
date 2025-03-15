extends TextEdit

var save_file_path = "user_text.txt" # The name of the file to save to

func _ready():
	load_text() # Load text when the scene starts

func _on_TextEdit_text_changed():
	save_text() # Save text whenever it changes

func save_text():
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	if file:
		file.store_string(self.text)
		file.close()
		print("Text saved!")
	else:
		print("Error saving text!")

func load_text():
	var file = FileAccess.open(save_file_path, FileAccess.READ)
	if file:
		self.text = file.get_as_text()
		file.close()
		print("Text loaded!")
	else:
		print("No saved text found.")
