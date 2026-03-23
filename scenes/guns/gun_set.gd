extends Node2D

# Possible gun types (Should be packed scenes which can instantiate a node extending BaseGun)
const available_gun_scenes := [
	# preload pistol
	# preload ar
	# preload shotgun
	preload("res://scenes/guns/revolver/revolver.tscn"),
	# preload sniper
	# preload gl
]

var is_reading_input: bool
var aiming: Vector2

@onready var enabled_guns: Array[BaseGun]

@onready var cur_gun: BaseGun
@onready var cur_gun_sprite: AnimatedSprite2D
@onready var gun_ind: int = 0
@onready var last_gun_ind: int = 0

func _init(guns_ready: Array[BaseGun] = [], aimpoint: Vector2 = Vector2.ZERO, reading_input: bool = false) -> void:
	enabled_guns = guns_ready
	set_aimpoint(aimpoint)
	set_reading_input(reading_input)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if len(enabled_guns) < 1:
		enabled_guns = [available_gun_scenes[0].instantiate()] # The pistol will always be available

	for gun in enabled_guns:
		gun.visible = false
		add_child(gun)
	
	select_gun(0)
	
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if !is_reading_input: return
	
	if event.is_action_pressed(&"select_gun1"): select_gun(0);
	if event.is_action_pressed(&"select_gun2"): select_gun(1);
	if event.is_action_pressed(&"select_gun3"): select_gun(2);
	if event.is_action_pressed(&"select_gun4"): select_gun(3);
	if event.is_action_pressed(&"select_gun5"): select_gun(4);

	if event.is_action_pressed(&"cycle_up"): select_gun(gun_ind + 1);
	if event.is_action_pressed(&"cycle_down"):
		var tmp := gun_ind - 1;
		if tmp < 0: tmp += len(enabled_guns)
		select_gun(tmp);

	# Yeah, this is gross, but I'm not sure if there's a better way of doing it
	return

func _physics_process(delta: float) -> void:
	if gun_ind != last_gun_ind:
		# Update held gun
		#$GunSprite.sprite_frames = gun_frames[gun_ind]
		cur_gun_sprite = enabled_guns[gun_ind].get_gun_sprite()
		last_gun_ind = gun_ind

	# Set animation frame of gun depending on cursor position

	return

func select_gun(index: int, mod: bool = true) -> int:
	enabled_guns[gun_ind].visible = false
	gun_ind = index % len(enabled_guns) if mod else gun_ind
	enabled_guns[gun_ind].visible = true
	return gun_ind

func set_reading_input(reading_input: bool) -> void:
	is_reading_input = reading_input
	
func get_reading_input() -> bool:
	return is_reading_input
	
func set_aimpoint(ap: Vector2) -> void:
	aiming = ap
	
func get_aimpoint() -> Vector2:
	return aiming
