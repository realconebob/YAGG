class_name BaseGun
extends Node2D

signal fired(bullets: Array[BaseEntity])
signal reloaded()

const dbpm: int = 12
const dmmags: int = 6

const dreload_dur: float = 3.0
const dbullet_dur: float = 0.1

var bullets_per_mag: int = dbpm
var bullets: int = bullets_per_mag
var max_mags: int = dmmags
var mags: int = max_mags
const ammo_defaults: Dictionary[String, int] = {
	bullets_per_mag = dbpm,
	bullets = dbpm,
	max_mags = dmmags,
	mags = dmmags
}

var reload_duration: float = dreload_dur
var bullet_duration: float = dbullet_dur
const timer_defaults: Dictionary[String, float] = {
	reload_t = dreload_dur,
	bullet_t = dbullet_dur
}

@onready var target: Vector2 = Vector2.ZERO
@onready var bpos: Vector2 = Vector2.ZERO

@onready var reload_timer: SceneTreeTimer = get_tree().create_timer(0)
@onready var bullet_timer: SceneTreeTimer = get_tree().create_timer(0)

func _init(ammo_map: Dictionary[String, int] = ammo_defaults, timer_map: Dictionary[String, float] = timer_defaults) -> void:
	if !ammo_map: ammo_map = ammo_defaults
	set_max_mags(ammo_map.get("max_mags", dmmags))
	set_bullets_per_mag(ammo_map.get("bullets_per_mag", dbpm))
	set_mags(ammo_map.get("mags", dmmags))
	set_bullets(ammo_map.get("bullets", dbpm))
	
	if !timer_map: timer_map = timer_defaults
	set_reload_duration(timer_map.get("reload_t", dreload_dur))
	set_bullet_cooldown(timer_map.get("bullet_t", dbullet_dur))
	return

func fire() -> void:
	print("bullets: %d, bullet_timer.time_left: %f" % [bullets, bullet_timer.time_left])
	if bullets <= 0 || bullet_timer.time_left > 0.0: return
	set_bullets(bullets - 1)
	bullet_timer = get_tree().create_timer(bullet_duration)
	fired.emit(make_bullets(target, bpos))
	return
	
func reload() -> void:
	print("mags: %d, reload_timer.time_left: %f, bullets: %d (out of per mag: %d)" % [mags, reload_timer.time_left, bullets, bullets_per_mag])
	if mags <= 0 || reload_timer.time_left > 0.0 || bullets == bullets_per_mag: return
	set_mags(mags - 1)
	set_bullets(bullets_per_mag)
	reload_timer = get_tree().create_timer(reload_duration)
	reloaded.emit()

func set_max_mags(mmags: int) -> void:
	max_mags = max(1, mmags)
func get_max_mags() -> int:
	return max_mags

func set_bullets_per_mag(bpm: int) -> void:
	bullets_per_mag = max(1, bpm)
	if bullets > bullets_per_mag:
		set_bullets(bullets_per_mag)
func get_bullets_per_mag() -> int:
	return bullets_per_mag

func set_mags(m: int) -> void:
	mags = max(0, min(m, max_mags))
func get_mags() -> int:
	return mags

func set_bullets(b: int) -> void:
	bullets = max(0, min(b, bullets_per_mag))
func get_bullets() -> int:
	return bullets

func set_reload_duration(reload_d: float) -> void:
	reload_duration = max(0.01, reload_d)
func get_reload_duration() -> float:
	return reload_duration

func set_bullet_cooldown(bullet_c: float) -> void:
	bullet_duration = max(0.01, bullet_c)
func get_bullet_cooldown() -> float:
	return bullet_duration

func set_target(t: Vector2) -> void:
	target = t
	
func get_target() -> Vector2:
	return target

func set_bullet_position(pos: Vector2) -> void:
	bpos = pos
	
func get_bullet_position() -> Vector2:
	return bpos

func make_bullets(_target: Vector2, _position: Vector2) -> Array[BaseEntity]:
	assert(false, "<BaseGun::make_bullets> Error: This function is to be overwritten, not called")
	return []

func get_handle() -> Node2D:
	assert(false, "<BaseGun::get_handle> Error: This function is to be overwritten, not called")
	return null
	
func get_barrel() -> Node2D:
	assert(false, "<BaseGun::get_barrel> Error: This function is to be overwritten, not called")
	return null
