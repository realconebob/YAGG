extends Node2D

# Possible gun types
const gun_frames := [
	preload("res://assets/guns/pistol_frames.tres"),
	preload("res://assets/guns/shotty_frames.tres"),
	# preload assault rifle
	# preload grenade launcher
	preload("res://assets/guns/sniper_frames.tres"),
]
# Largest valid index in gun_frames array
const gun_frames_max := (len(gun_frames) - 1)

@onready var gun_ind := 0
@onready var last_gun_ind := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"select_gun1"):
		gun_ind = 0;
		return

	if event.is_action_pressed(&"select_gun2"):
		gun_ind = 1;
		return

	if event.is_action_pressed(&"select_gun3"):
		gun_ind = 2;
		return

	if event.is_action_pressed(&"select_gun4"):
		gun_ind = 3;
		return

	if event.is_action_pressed(&"select_gun5"):
		gun_ind = 4;
		return

	if event.is_action_pressed(&"cycle_up"):
		gun_ind = (gun_ind + 1) % (gun_frames_max + 1);
		return

	if event.is_action_pressed(&"cycle_down"):
		var tmp := gun_ind - 1;
		if tmp < 0:
			tmp += (gun_frames_max + 1)

		gun_ind = tmp;
		return

	# Yeah, this is gross, but I'm not sure if there's a better way of doing it
	return

func _physics_process(delta: float) -> void:
	if gun_ind != last_gun_ind:
		$GunSprite.sprite_frames = gun_frames[gun_ind]
		last_gun_ind = gun_ind

	# Set animation frame of gun depending on cursor position

	return
