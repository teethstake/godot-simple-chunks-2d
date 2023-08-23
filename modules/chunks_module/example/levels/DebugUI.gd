extends CanvasLayer

func _process(_delta: float) -> void:
	
	var cm = get_tree().current_scene.find_node('ChunkManager') as ChunkManagerBase
	
	var mem_usage: float = cm.chunks_memory_usage;
	
	$Label.text = '%s fps\n%s objects\n%s rooms (%s loaded)' % [
		Engine.get_frames_per_second(),
		Performance.get_monitor(Performance.OBJECT_COUNT),
		cm.chunks.size(),
		cm.get_child_count(),
	];
	
	if mem_usage:
		$Label.text += '\nchunks data memory usage: %.2f MB' % mem_usage
