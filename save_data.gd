class_name SaveData
extends Node

const SAVE_FILE = "user://data.save"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Returns save data
func load_data() -> Dictionary:
	if not FileAccess.file_exists(SAVE_FILE):
		var empty = {}
		return empty
	
	var json_string = FileAccess.get_file_as_string(SAVE_FILE)
	var results = JSON.parse_string(json_string)
	
	return results


func save(comic: Comic):
	var current_data: Dictionary = load_data()
	current_data[comic.comic_name] = {"chapter_numbers": comic.chapter_numbers,
										"chapter_urls": comic.chapter_urls,
										"comic_url": comic.comic_url}
	var file_write = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file_write.store_line(JSON.stringify(current_data))

func load_comics() ->Array[Comic]:
	var comic_list: Array[Comic]
	var data: Dictionary= load_data()
	if data.keys():
		for key in data.keys():
			var comic := Comic.new()
			comic.comic_name = key
			comic.chapter_numbers.append_array(data[key]["chapter_numbers"])
			comic.chapter_urls.append_array(data[key]["chapter_urls"])
			comic.comic_url = data[key]["comic_url"]
			comic_list.append(comic)
	
	return comic_list
