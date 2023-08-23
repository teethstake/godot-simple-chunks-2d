extends YSort
class_name ChunkManagerBase

var chunks := {};

var loaded_chunks := {};

var entered_chunks := [];

const NULL_KEY := Vector2.ONE * -999.125;

var chunks_memory_usage: float;

# chunks[key][ID_C.something]
enum ID_C {
	PACKED_SCENE,
	NEIGHBOUR_LEFT,
	NEIGHBOUR_RIGHT,
	NEIGHBOUR_TOP,
	NEIGHBOUR_BOTTOM,
	SPAWNER_TILEMAP_BLACKLIST,
};

# loaded_chunks[key][ID_LC.something]
enum ID_LC {
	SCENE,
	LOAD_COUNT,
};



func add_chunk(
			pos: Vector2, chunk_scene: PackedScene,
			neighbour_left: Vector2, neighbour_right: Vector2,
			neighbour_top: Vector2, neighbour_bottom: Vector2#,
	) -> void:
	
	chunks[pos] = [
		chunk_scene,
		# TODO: put neighbours into an array
		neighbour_left,
		neighbour_right,
		neighbour_top,
		neighbour_bottom,
		[],
	];
	
func add_heavy_chunk(
			pos: Vector2, chunk: HeavyChunk,
			neighbour_left: Vector2, neighbour_right: Vector2,
			neighbour_top: Vector2, neighbour_bottom: Vector2#,
	) -> void:
	
	chunks[pos] = [
		chunk.get_children_save(),
		# TODO: put neighbours into an array
		neighbour_left,
		neighbour_right,
		neighbour_top,
		neighbour_bottom,
		[],
	];


func find_chunk_key(position: Vector2) -> Vector2:

	var smallest_distance := 1_000_000.0;
	var key := NULL_KEY;
	
	for k in chunks.keys():
		# assumption: chunks origin is in its top left corner
		if position.x >= k.x and position.y >= k.y and position.distance_to(k) < smallest_distance:
			smallest_distance = position.distance_to(k);
			key = k;
	
	return key;



func load_chunk(key: Vector2) -> void:
	var chunk_data = chunks[key];
	
	if chunk_data[0] is PackedScene:
		var chunk := chunk_data[ID_C.PACKED_SCENE].instance() as Chunk;
		chunk.position = key;
		call_deferred('add_child', chunk);
		chunk.call_deferred('emit_signal', 'loaded');
		loaded_chunks[key] = [chunk, 0];
		
	elif chunk_data[0] is Array:
		var chunk: HeavyChunk = load("res://modules/chunks_module/chunks/HeavyChunk.tscn").instance();
		chunk.position = key;
		call_deferred('add_child', chunk);
		chunk.call_deferred('load_children_save', chunk_data[0]);
		chunk.call_deferred('emit_signal', 'loaded');
		loaded_chunks[key] = [chunk, 0];


func try_loading_chunk(key: Vector2) -> void:
	if key != NULL_KEY:
		if not key in loaded_chunks:
			load_chunk(key);
		loaded_chunks[key][ID_LC.LOAD_COUNT] += 1;


func try_loading_neighbours(key: Vector2) -> void:
	var chunk_data: Array = chunks[key];
	
	try_loading_chunk(chunk_data[ID_C.NEIGHBOUR_LEFT]);
	try_loading_chunk(chunk_data[ID_C.NEIGHBOUR_RIGHT]);
	try_loading_chunk(chunk_data[ID_C.NEIGHBOUR_TOP]);
	try_loading_chunk(chunk_data[ID_C.NEIGHBOUR_BOTTOM]);


func load_first_chunk(key: Vector2) -> void:
	try_loading_chunk(key)
	loaded_chunks[key][ID_LC.LOAD_COUNT] = 0;


func unload_chunk(key: Vector2) -> void:
	loaded_chunks[key][ID_LC.SCENE].emit_signal('unloaded')
	(loaded_chunks[key][ID_LC.SCENE]).queue_free();
# warning-ignore:return_value_discarded
	loaded_chunks.erase(key);


func try_unloading_chunk(key: Vector2) -> void:
	if key != NULL_KEY:
		loaded_chunks[key][ID_LC.LOAD_COUNT] -= 1;
		if not key in entered_chunks and loaded_chunks[key][ID_LC.LOAD_COUNT] < 1:
			unload_chunk(key);


func try_unloading_neighbours(key: Vector2) -> void:
	var chunk_data: Array = chunks[key];
	
	try_unloading_chunk(chunk_data[ID_C.NEIGHBOUR_LEFT]);
	try_unloading_chunk(chunk_data[ID_C.NEIGHBOUR_RIGHT]);
	try_unloading_chunk(chunk_data[ID_C.NEIGHBOUR_TOP]);
	try_unloading_chunk(chunk_data[ID_C.NEIGHBOUR_BOTTOM]);


func reload_chunk(key: Vector2) -> void:
	if key in loaded_chunks:
#		var copy = loaded_chunks[key];
		unload_chunk(key);
		load_chunk(key);
#		loaded_chunks[key] = copy;


func get_spawner_tilemap_blacklist(key: Vector2) -> Array:
	return chunks[key][ID_C.SPAWNER_TILEMAP_BLACKLIST];


func populate_chunks_dictionary() -> bool: return false; # virtual


