extends CanvasLayer

# Getter for current url
func get_url() -> String:
	# Sanitize url
	var url = $TextEditUrl.text
	if (url.begins_with("http://") || url.begins_with("https://")):
		return url
	return "http://" + url

func _on_button_enter_url_pressed():
	# Get site data
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	var error = http_request.request(get_url())

func _http_request_completed(result, response_code, hears, body):
	display_list(body.get_string_from_utf8())

func display_list(text: String):
	# Find single element with image
	var regex = RegEx.new()
	regex.compile("(?<=\")(((?!\").)*)(?!=\\s)*.jpg")
	var results = regex.search_all(text)
	for result in results:
		var image_url = result.get_string().replace(" ", "")
		var http_request = HTTPRequest.new()
		add_child(http_request)
		http_request.request_completed.connect(self._image_request_completed)
		print(image_url)
		var regrep = RegEx.new()
		regrep.compile("\\s")
		image_url=regrep.sub(image_url, "", true)
		
		var error = http_request.request(image_url)

func _image_request_completed(result, response_code, hears, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image download failure")

	var image = Image.new()
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
		push_error("Image load failure")
	var texture = ImageTexture.create_from_image(image)

	var texture_rect = TextureRect.new()
	$ScrollContainer.find_child("VBoxContainer").add_child(texture_rect)
	texture_rect.texture = texture
