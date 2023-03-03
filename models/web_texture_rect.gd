class_name WebTextureRect
extends TextureRect

enum IMGTYPE {JPG, PNG}

@export var raw_type: IMGTYPE
@export var raw_bytes: Array
@export var url: String

func load_from_url(url: String):
	self.url = url
	var http_request = HTTPRequest.new()
	http_request.request_completed.connect(self._image_request_completed)
	add_child(http_request)
	var error = http_request.request(url)


func _image_request_completed(result, response_code: int, hears, body):
	if result != HTTPRequest.RESULT_SUCCESS or hears[1].contains("text"):
		push_warning("Image download failure url: " + url)
		push_warning("Image download failure response code: %d" % response_code)
		return

	var error
	var image := Image.new()
	# TODO add all types
	# Verify image type
	if hears[1].contains("jpeg") or hears[1].contains("jpg"):
		raw_type = IMGTYPE.JPG
		error = image.load_jpg_from_buffer(body)
	else:
		raw_type = IMGTYPE.PNG
		error = image.load_png_from_buffer(body)
	
	if error != OK:
		push_error("Image load failure")
		
	self.texture = ImageTexture.create_from_image(image)
	
