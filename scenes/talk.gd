extends Node

var api_key = "YOUR_API_KEY"
var api_url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"

@onready var http_request = HTTPRequest.new()
@onready var label = $Label
@onready var line_edit = $QuestionInput

func _ready():
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed_handler"))

	if has_node("AskButton"):
		$AskButton.connect("pressed", Callable(self, "_on_ask_button_pressed"))
		query_gemini('''Hello, You are roleplaying talking to a person with Dissociative Personality Disorder.


This is a form of Congnitive Behavioural Therapy.


You are currently talking to an alter named Aarna


Please

1. Note down any issues they have with other alters at the end of the Message using a paragraph that starts with "Issues:"

2. Please note down the emotions they're feeling at the end of the Message using a paragraph that starts with "Emotions:"

2. Please do not make the other alter believe you have empathy and are an actual human person

3. If they are showing tendancies to hurt themselves or someone around them, please advise them to go to therapy

4.Please be kind and Patient to them

5. Please be casual and act as a friend

6. Make your messages less verbose and more like dialogue ''')

func _on_ask_button_pressed():
	var question = line_edit.text
	if !question.is_empty():
		query_gemini(question)
	else:
		label.text = "Please enter a question."

func query_gemini(prompt):
	var headers = [
		"Content-Type: application/json",
		"x-goog-api-key: " + api_key
	]

	var request_data = {
		"contents": [{
			"parts": [{
				"text": prompt
			}]
		}]
	}

	var err = http_request.request(api_url, headers, HTTPClient.METHOD_POST, JSON.stringify(request_data))

	if err != OK:
		print("Error sending request:", err)
		label.text = "Request Error"

func _on_request_completed_handler(result, response_code, headers, body, _user_data): # Prefixed _user_data
	_on_request_completed(result, response_code, headers, body)

func _on_request_completed(result, response_code, _headers, body): # Prefixed _headers
	if result != HTTPRequest.RESULT_SUCCESS:
		print("HTTP Request failed:", result, response_code)
		label.text = "HTTP Error"
		return

	var json_string = body.get_string_from_utf8()
	var json = JSON.new()
	var json_result = json.parse(json_string)

	if json_result != OK:
		print("JSON parsing error:", json.get_error_message())
		label.text = "JSON Error"
		return

	var data = json.get_data()

	if data.has("candidates") and data.candidates.size() > 0:
		var response_text = data.candidates[0].content.parts[0].text
		label.text = response_text
	else:
		label.text = "No response from Gemini"
		print("No response from Gemini")
