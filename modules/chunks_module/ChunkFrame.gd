extends Node2D
class_name ChunkFrame

#tool
#
#export var tool_spawn_chunk := false setget set_tool_spawn_chunk;
#
#func set_tool_spawn_chunk(new_value: bool) -> void:
#	if chunk_path:
#		tool_spawn_chunk = new_value;
#		if tool_spawn_chunk:
#			force_spawn();
#		else:
#			force_despawn();

var chunk_path: String;
var is_loaded := true;
var loaded_count := 1;
var is_chunk_loader_inside := false;

# list of indexes
var spawner_tilemap_blacklist := [];

#export var custom_neighbours := false;

export var automap_left := true;
export var neighbour_left: NodePath;

export var automap_right := true;
export var neighbour_right: NodePath;

export var automap_top := true;
export var neighbour_top: NodePath;

export var automap_bottom := true;
export var neighbour_bottom: NodePath;

func get_chunk() -> ChunkBase:
	# yea, it's error prone, when adding new nodes
	return get_child(0) as ChunkBase;

func _ready() -> void:
	if get_chunk() is Chunk:
		chunk_path = get_chunk().self_path;

