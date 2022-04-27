extends Spatial

export(String) var block_folder_path = "res://Wave_Front_Collapse/Block_Data"

var block_list

func _ready():
	
	init(block_folder_path);
	

func init(block_data_folder_path):
	
	var block_files = _list_files_in_directory(block_data_folder_path)
	
	_generate_dictionary_from_files(block_files)
	
	_load_data_from_files(block_data_folder_path, block_files)
	
	print(block_list)
	

func _generate_dictionary_from_files(files):
	block_list = Dictionary()
	for file in files:
		var block_identification_data = get_node("Blocks_Parser").parse_block_file_name(file)
		
		var id = block_identification_data[0]
		var variant = block_identification_data[1]
		var block_name = block_identification_data[2]
		
		if !block_list.has(id):
			block_list[id] = Array()
		
		block_list[id].insert(variant, [block_name])
	
	

func _load_data_from_files(path, files):
	
	for file in files:
		
		var file_data = File.new()
		file_data.open(path + "/" + file, File.READ)
		var content = file_data.get_as_text()
		file_data.close()
		
		var block_data = get_node("Blocks_Parser").parse_block_file_data(content)
		var full_id = file.split("-")[0]
		var id = full_id.split(".")[0]
		var variant = full_id.split(".")[1]
		
		for item in block_data:
			block_list[id][int(variant)].append(item)
		
	

func _list_files_in_directory(path):
	
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	
	dir.list_dir_end()
	
	return files
