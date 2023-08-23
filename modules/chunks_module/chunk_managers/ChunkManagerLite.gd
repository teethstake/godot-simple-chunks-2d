extends ChunkManagerBase
class_name ChunkManagerLite

export var chunks_as_string: String setget set_chunks_as_string;



func set_chunks_as_string(new_value: String) -> void:
	chunks_as_string = new_value;

	
func _ready() -> void:
	
# warning-ignore:return_value_discarded
	populate_chunks_dictionary()
	
	var cl = get_tree().current_scene.find_node('ChunkLoader');

	if cl:
		var key = find_chunk_key(cl.get_parent().position)

		load_first_chunk(key);


func populate_chunks_dictionary() -> bool:
	if chunks_as_string:
		# TODO: reading from a file maybe?
		var mem_before := Performance.get_monitor(Performance.MEMORY_STATIC);
		chunks = str2var(chunks_as_string);
		var mem_after := Performance.get_monitor(Performance.MEMORY_STATIC);
		var mem_usage := (mem_after - mem_before) / 1000000.0;
		chunks_memory_usage = mem_usage;
#		print('Chunks memory ussage: %s MB' % mem_usage)
		
		mem_before = Performance.get_monitor(Performance.MEMORY_STATIC);
		chunks_as_string = '';
		mem_after = Performance.get_monitor(Performance.MEMORY_STATIC);
		mem_usage = abs(mem_after - mem_before) / 1000000.0;
		print_debug('Memory freed from chunks_as_string: %.2f MB' % mem_usage)
		
		return true;
	else:
		push_error('You have to paste the chunks data into chunks_as_string export variable')
		get_tree().quit(-1);
		return false;
		
	

