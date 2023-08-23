extends ChunkBase
class_name HeavyChunk

# BUG: permamently despawining nodes spawned by a SpawnerTileMap doesnt work with HeavyChunks

func get_children_save() -> Array:
	var arr := [];
	for child in get_children():
		# TODO: make it recursive
		arr.append(var2bytes(child, true));
	
	return arr;


func load_children_save(arr: Array) -> void:
	for child_str in arr:
		var inst = bytes2var(child_str, true);
		add_child(inst);
