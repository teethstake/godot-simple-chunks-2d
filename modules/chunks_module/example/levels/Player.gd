extends KinematicBody2D

const speed := 1000 * 60;

enum mouse_buttons {BUTTON_LEFT=BUTTON_LEFT, BUTTON_RIGHT=BUTTON_RIGHT}

export (mouse_buttons) var mouse_button: int = BUTTON_LEFT; 

func _physics_process(delta: float) -> void:
	
	if Input.is_mouse_button_pressed(mouse_button):
		$Camera2D.current = true;
		var direction := (get_global_mouse_position() - position).normalized();
# warning-ignore:return_value_discarded
		move_and_slide(direction * delta * speed);
