class_name BaseGun
extends Node2D

signal fired(bullets: Array[BaseEntity])

const dbullet_dur: float = 0.1

var bullet_cooldown: float = dbullet_dur:
	set(n): bullet_cooldown = max(0.01, n)

var can_fire: bool = true

@onready var target: Vector2 = Vector2.ZERO:
	set(t): target = t
@onready var bpos: Vector2 = Vector2.ZERO:
	set(b): bpos = b
@onready var pointing_angle: Vector2 = Vector2.ZERO:
	set(a): pointing_angle = a

@onready var bullet_timer: SceneTreeTimer = get_tree().create_timer(0)

@onready var cost: float = 5.0:
	set(n): cost = max(0, n)

func _init(bc: float = dbullet_dur) -> void:	
	bullet_cooldown = bc
	return

func fire() -> bool:
	if !can_fire or bullet_timer.time_left > 0: return false
	bullet_timer = get_tree().create_timer(bullet_cooldown)
	fired.emit(make_bullets(target, bpos, pointing_angle))
	return true

func make_bullets(_target: Vector2, _position: Vector2, _o: Vector2) -> Array[BaseEntity]:
	assert(false, "<BaseGun::make_bullets> Error: This function is to be overwritten, not called")
	return []

func get_handle() -> Node2D:
	assert(false, "<BaseGun::get_handle> Error: This function is to be overwritten, not called")
	return null
	
func get_barrel() -> Node2D:
	assert(false, "<BaseGun::get_barrel> Error: This function is to be overwritten, not called")
	return null
