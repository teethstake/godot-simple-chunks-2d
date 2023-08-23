extends ChunkManagerBase
class_name ChunkManager

export var copy_chunks_dictionary_to_clipboard := true;

func _ready() -> void:
	var cnm := get_tree().current_scene.find_node('ChunkNeighbourMapper');
	if cnm:
		cnm.map_all_chunks_and_self_destruct(self);
	
# warning-ignore:return_value_discarded
	populate_chunks_dictionary();
	
	if copy_chunks_dictionary_to_clipboard:
		OS.clipboard = var2str(chunks);
	
	
	var cl = get_tree().current_scene.find_node('ChunkLoader');
	
	if cl:
		destroy_chunk_frames();
		
		var key = find_chunk_key(cl.get_parent().position)
		
		load_first_chunk(key);


func populate_chunks_dictionary() -> bool:
	var mem_before := Performance.get_monitor(Performance.MEMORY_STATIC);
	var chunk_scenes := {};
	
	for chunk_frame in get_children():
#		chunk_frame = chunk_frame as ChunkFrame;
		
		var nl = chunk_frame.get_node_or_null(chunk_frame.neighbour_left);
		var nr = chunk_frame.get_node_or_null(chunk_frame.neighbour_right);
		var nt = chunk_frame.get_node_or_null(chunk_frame.neighbour_top);
		var nb = chunk_frame.get_node_or_null(chunk_frame.neighbour_bottom);
		
		
		if chunk_frame.position == NULL_KEY:
			push_error("ChunkFrame's position can't be equal to %s, this is a value reserved for the NULL_KEY" % NULL_KEY);
			get_tree().quit(1);
		
		
		var chunk = chunk_frame.get_chunk();
		
		
		if chunk is Chunk:
#			chunk = chunk as Chunk;
			
			var chunk_path: String = chunk.self_path;

			if not chunk_path in chunk_scenes:
				chunk_scenes[chunk_path] = load(chunk_path);

			add_chunk(
				chunk_frame.position,
				chunk_scenes[chunk_path],
				nl.position if nl else NULL_KEY,
				nr.position if nr else NULL_KEY,
				nt.position if nt else NULL_KEY,
				nb.position if nb else NULL_KEY
			);
		
			
		elif chunk is HeavyChunk:

			add_heavy_chunk(
				chunk_frame.position,
				chunk,
				nl.position if nl else NULL_KEY,
				nr.position if nr else NULL_KEY,
				nt.position if nt else NULL_KEY,
				nb.position if nb else NULL_KEY
			);

	var mem_after := Performance.get_monitor(Performance.MEMORY_STATIC);
	chunks_memory_usage = (mem_after - mem_before) / 1000000.0;
	return true;


func destroy_chunk_frames() -> void:
	for chunk_frame in get_children():
		chunk_frame = chunk_frame as ChunkFrame;
		chunk_frame.call_deferred('queue_free');

