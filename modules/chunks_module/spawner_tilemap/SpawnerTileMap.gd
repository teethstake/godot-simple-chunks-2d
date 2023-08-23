extends TileMap

# it's all hardcoaded, because i didn't have a better idea and i see no reason for having more than
# 1 of those

# IDs of your atlas tiles (corresponding to their IDs in the TileSet
enum TILE_ID {PICKUPS=0};

var is_exiting_tree := false;

# here preload the scenes of the things you will be spawning
const pickup_scene := preload("res://modules/chunks_module/example/pickups/PickUp.tscn");
const coin_scene := preload("res://modules/chunks_module/example/pickups/Coin.tscn");



# scenes[tile_id][position_in_autotile] = scene
const scenes := {
	TILE_ID.PICKUPS: {
		# Vector2 coresponds to the position of the tile in the atlas. (0, 0) is the first one
		# (1, 0) is the second one. If there were another row, the nex two tiles would be (0, 1)
		# and (1, 1)
		Vector2(0, 0): pickup_scene,
		Vector2(1, 0): coin_scene,
	},
};


func get_blacklist() -> Array:
	var cm := get_tree().current_scene.find_node('ChunkManager');
	return cm.get_spawner_tilemap_blacklist(get_parent().position);


func spawn(id: int, pos: Vector2, index: int) -> void:
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
	var scene = scenes[id][get_cell_autotile_coord(pos.x, pos.y)];
	var inst = scene.instance();

	inst.position = map_to_world(pos) + cell_size / 2;

	if inst.is_in_group('stm_dont_respawn'):
		inst.set_meta('stm_index', index);

	add_child(inst);


func spawn_all() -> void:

	var blacklist := get_blacklist();

	var index := 0;

	for id in TILE_ID.values():
		for pos in get_used_cells_by_id(id):

			if not index in blacklist:
				spawn(id, pos, index);

			set_cell(pos.x, pos.y, -1);
			index += 1;


func _ready() -> void:
	var chunk := get_parent() as ChunkBase;

# warning-ignore:return_value_discarded
	chunk.connect("loaded", self, "_on_Chunk_loaded");
# warning-ignore:return_value_discarded
	chunk.connect("unloaded", self, "_on_Chunk_unloaded");


func _on_Chunk_loaded() -> void:
	spawn_all();

# WARNING: needs manual connection
func _on_Chunk_unloaded() -> void:
	is_exiting_tree = true;


func _on_SpawnerTileMap_child_exiting_tree(node: Node) -> void:
	
	if not is_exiting_tree and node.is_in_group('stm_dont_respawn'):
		var chunk := get_parent() as ChunkBase;
		var cm := chunk.get_parent() as ChunkManagerBase;
		var index: int = node.get_meta('stm_index');
		cm.get_spawner_tilemap_blacklist(chunk.position).append(index);


