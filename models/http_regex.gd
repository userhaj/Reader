class_name HttpRegex
extends Node

@export var regex: String
@export var results: Array[String]
@export var url: String

signal http_get_complete

func get_results(_url: String, _regex: String):
	self.url = _url
	self.regex = _regex
	var http_request = HTTPRequest.new()
	http_request.request_completed.connect(self._http_request_completed)
	add_child(http_request)
	http_request.request(self.url)


func _http_request_completed(result, _response_code: int, _hears, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_warning("Http download failure url: " + url)
	
	var regex_search := RegEx.new()
	regex_search.compile(regex)
	var site = body.get_string_from_utf8().replace("\n", "").replace("\r", "")
	var matches = regex_search.search_all(site)
	for reg_match in matches as Array[RegExMatch]:
		results.append(reg_match.get_string())
	emit_signal("http_get_complete", results, self)
		
		
