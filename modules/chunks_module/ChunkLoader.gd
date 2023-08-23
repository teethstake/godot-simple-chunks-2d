extends Area2D
class_name ChunkLoader

onready var chunk_manager: ChunkManagerBase;
export var active := false setget set_active;

var entered_chunks := [];

func set_active(new_value: bool) -> void:
	active = new_value;
	$CollisionShape2D.disabled = not active;

func _ready() -> void:
	set_active(active);
	chunk_manager = get_tree().current_scene.find_node('ChunkManager')

func _on_ChunkLoader_area_exited(area: Area2D) -> void:
	entered_chunks.erase(area.position);
	chunk_manager.entered_chunks.erase(area.position);
	chunk_manager.try_unloading_neighbours(area.position);


func _on_ChunkLoader_area_entered(area: Area2D) -> void:
	entered_chunks.append(area.position);
	chunk_manager.entered_chunks.append(area.position);
	chunk_manager.try_loading_neighbours(area.position);
	
#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_cancel"):
#		reload_chunks();

func reload_chunks() -> void:
	for key in entered_chunks:
		chunk_manager.reload_chunk(key);
	
	
#	return
#	if $ReloadTimer.time_left:
#		return
#
#	var ec := entered_chunks.duplicate();
#
#	for key in ec:
#		chunk_manager.try_unloading_chunk(key)
#
#	$ReloadTimer.start();
#	yield($ReloadTimer, "timeout");
#
#	for key in ec:
#		chunk_manager.try_loading_chunk(key)


#func reload_entered_chunk() -> void:
#	if $ReloadTimer.time_left:
#		return
#
#	var ecs := entered_chunk_frames.duplicate();
#
#	for cs in ecs:
#		cs.force_despawn();
#
#	$ReloadTimer.start();
#	yield($ReloadTimer, "timeout");
#
#	for cs in ecs:
##		cs.spawn();

