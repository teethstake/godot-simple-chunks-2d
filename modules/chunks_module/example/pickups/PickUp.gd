extends Area2D

func _on_PickUp_body_entered(_body: Node) -> void:
	queue_free();

func _ready() -> void:
	$Tween.interpolate_property(self, 'rotation', 0, 2*PI, 1.0);
	$Tween.start();
