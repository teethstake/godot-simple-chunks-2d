extends Area2D
class_name ChunkBase

# warning-ignore:unused_signal
signal loaded;
# warning-ignore:unused_signal
signal unloaded;

func get_center() -> Vector2:
	return $CollisionShape2D.position;
	
func get_extents() -> Vector2:
	return $CollisionShape2D.shape.extents;
