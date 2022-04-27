extends Node

func parse_block_file_name(file_name):
	
	# Name and full ID
	var split_name = file_name.split("-")
	
	var full_id = split_name[0]
	var block_name = split_name[1].split(".")[0].replace("_", " ")
	
	# Id split and variant
	var full_id_split = full_id.split(".")
	
	var id = full_id_split[0]
	var variant = full_id_split[1]
	
	return [id, variant, block_name] # 0000, 00, block name

func parse_block_file_data(file_data):
	
	var mesh_id
	var constraints = Dictionary()
	
	file_data = file_data.split("\n")
	
	var data_mod = 0
	
	for line in file_data:
		
		match data_mod:
			
			1: # in constraints tab
				
				if line == "}":
					data_mod = 0
					continue
				
				var constraint_name = line.trim_prefix("\t").split("(")[0]
				var constraint_data = Array()
				
				constraints[constraint_name] = constraint_data
				
				# Setup Attribute(s)
				var regex = RegEx.new()
				regex.compile("\\((.*?)\\)")
				var result = regex.search(line)
				
				if result:
					constraint_data = result.get_string().trim_prefix("(").trim_suffix(")").split(",")
					for value in constraint_data:
						constraints[constraint_name].append(value)
			
			
			_: # Normal
				
				var attributes = line.split(":")
				
				match attributes[0]:
					
					"mesh_id":
						mesh_id = attributes[1]
					
					"constraints":
						data_mod = 1
					
					_:
						push_error(attributes[0] + " is not define in the attributes")
	
	return [mesh_id, constraints]



