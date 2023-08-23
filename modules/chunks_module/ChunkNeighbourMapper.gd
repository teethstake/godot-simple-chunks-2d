extends RayCast2D
#class_name ChunkNeighbourMapper
#tool


#export var bake := false setget set_bake;
#
#func set_bake(new_bake: bool) -> void:
#	bake = new_bake;
#
#	var cm := get_node_or_null("../ChunkManager");
#
#	if not cm:
#		push_error('Chunk Manager node not found in $"../ChunkManager"');
#		return;
#
#	if bake:
#		map_all_chunks(cm);
#	else:
#		unmap_all_chunks(cm);
	
func map_neighbours(chunk_frame: ChunkFrame) -> void:
	chunk_frame = chunk_frame as ChunkFrame;
	var center: Vector2 = chunk_frame.get_chunk().get_center() + chunk_frame.position
	var chunk_extents: Vector2 = chunk_frame.get_chunk().get_extents();
	
	if chunk_frame.automap_left and not chunk_frame.neighbour_left:
		position = center - Vector2(chunk_extents.x+1, chunk_extents.y-1)
		cast_to = Vector2(-1, chunk_extents.y*2-2);
		force_raycast_update();
		
		if is_colliding():
			chunk_frame.neighbour_left = chunk_frame.get_path_to(get_collider().get_parent());
	
	if chunk_frame.automap_right and not chunk_frame.neighbour_right:
		position = center + Vector2(chunk_extents.x+1, -chunk_extents.y+1)
		cast_to = Vector2(1, chunk_extents.y*2-2);
		force_raycast_update();
		
		if is_colliding():
			chunk_frame.neighbour_right = chunk_frame.get_path_to(get_collider().get_parent());
	
	
	if chunk_frame.automap_top and not chunk_frame.neighbour_top:
		position = center - Vector2(chunk_extents.x-1, chunk_extents.y+1)
		cast_to = Vector2(chunk_extents.x*2-2, -1);
		force_raycast_update();
		
		if is_colliding():
			chunk_frame.neighbour_top = chunk_frame.get_path_to(get_collider().get_parent());
	
	
	if chunk_frame.automap_bottom and not chunk_frame.neighbour_bottom:
		position = center + Vector2(chunk_extents.x-1, chunk_extents.y+1)
		cast_to = Vector2(-chunk_extents.x*2+2, 1);
		force_raycast_update();
		
		if is_colliding():
			chunk_frame.neighbour_bottom = chunk_frame.get_path_to(get_collider().get_parent());
			
			
#	print('l: %s' % chunk_frame.neighbour_left)
#	print('r: %s' % chunk_frame.neighbour_right)
#	print('u: %s' % chunk_frame.neighbour_top)
#	print('d: %s' % chunk_frame.neighbour_bottom)

func map_all_chunks(chunk_manager) -> void:
	for chunk_frame in chunk_manager.get_children():
		map_neighbours(chunk_frame);

func map_all_chunks_and_self_destruct(chunk_manager) -> void:
	map_all_chunks(chunk_manager)
	queue_free();

#func unmap_all_chunks(chunk_manager) -> void:
#	for chunk_frame in chunk_manager.get_children():
#		if not chunk_frame.custom_neighbours:
#			chunk_frame = chunk_frame as ChunkFrame;
#			chunk_frame.neighbour_left = '';
#			chunk_frame.neighbour_right = '';
#			chunk_frame.neighbour_top = '';
#			chunk_frame.neighbour_bottom = '';
