extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.mac_collided.connect(mac_detect_collision)
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	$BasicZombie.set_target($Player.position)
	return

func mac_detect_collision(collider: KinematicCollision2D) -> void:
	print("COLLISION! Collider type: %s" % [collider.get_collider().get_class()])
	return
