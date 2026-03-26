extends BaseEntity

func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(_handle_offscreen)
	set_health(5)

func get_type() -> String:
	return "Bullet"
		
func _handle_offscreen() -> void:
	queue_free()
