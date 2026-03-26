class_name BaseGun
extends Node2D

signal fired(bullets: Array[BaseEntity], bullets_left: int)
signal reloaded(mags_left: int)


const dbullet_cooldown: float = 0.3
const dreload_duration: float = 1.5
const timer_defaults: Dictionary[String, Variant] = {
	bcool = dbullet_cooldown,
	redur = dreload_duration
}

const dbullet_scene: PackedScene = null
const dapm: int = 12
const dmags: int = 6
const dcmags: int = dmags
const dcammo: int = dapm
const bullet_defaults: Dictionary[String, Variant] = {
	scene = dbullet_scene,
	apm = dapm,
	mmags = dmags,
	cmags = dcmags,
	cammo = dcammo,
}


var bullet_scene: PackedScene = dbullet_scene
var bullet_cooldown: float = dbullet_cooldown
var reload_duration: float = dreload_duration

var ammo_per_mag: int = dapm
var max_mags: int = dmags
var cur_ammo: int = dcammo
var cur_mags: int = dcmags

var target: Vector2 = Vector2.ZERO
var bpos: Vector2 = Vector2.ZERO

@onready var bullet_timer: SceneTreeTimer = null
@onready var reload_timer: SceneTreeTimer = null

func _init(timer_map: Dictionary[String, Variant] = timer_defaults, bullet_map: Dictionary[String, Variant] = bullet_defaults) -> void:
	if !timer_map: timer_map = timer_defaults
	set_bullet_cooldown(timer_map.get("bcool", dbullet_cooldown))
	set_reload_duration(timer_map.get("redur", dreload_duration))
	
	if !bullet_map: bullet_map = bullet_defaults
	set_bullet_scene(bullet_map.get("scene", dbullet_scene))
	set_ammo_per_mag(bullet_map.get("apm", dapm))
	set_max_mags(bullet_map.get("mmags", dmags))
	set_mags(bullet_map.get("cmags", dcmags))
	set_ammo(bullet_map.get("cammo", dcammo))
	
	return

func set_target(t: Vector2) -> void:
	target = t
func get_target() -> Vector2:
	return target
	
func set_bullet_pos(b: Vector2) -> void:
	bpos = b
func get_bullet_pos() -> Vector2:
	return bpos

func fire() -> void:
	if !bullet_scene or bullet_timer or reload_timer or cur_ammo <= 0 : return
	set_ammo(cur_ammo - 1)
	bullet_timer = get_tree().create_timer(bullet_cooldown, false, true)
	fired.emit(create_bullets(target, bpos), cur_ammo)

func create_bullets(_target: Vector2, _bpos: Vector2) -> Array[BaseEntity]:
	assert(false, "<BaseGun::create_bullets> Error: This function is to be overwritten")
	return []

func get_barrel() -> Node2D:
	assert(false, "<BaseGun::get_barrel> Error: This function is to be overwritten")
	return null

func get_handle() -> Node2D:
	assert(false, "<BaseGun::get_handle> Error: This function is to be overwritten")
	return null

func reload() -> void:
	if reload_timer or cur_ammo == ammo_per_mag or cur_mags <= 0: return
	set_mags(cur_mags - 1)
	set_ammo(get_ammo_per_mag())
	reload_timer = get_tree().create_timer(reload_duration, false, true)
	reloaded.emit(cur_mags)
	return
	

func set_bullet_scene(bs: PackedScene) -> void:
	bullet_scene = bs
func get_bullet_scene() -> PackedScene:
	return bullet_scene

func set_bullet_cooldown(cd: float) -> void:
	bullet_cooldown = max(0.01, cd)
func get_bullet_cooldown() -> float:
	return bullet_cooldown
	
func set_reload_duration(rd: float) -> void:
	reload_duration = max(0.01, rd)
func get_reload_duration() -> float:
	return reload_duration

func set_ammo_per_mag(apm: int) -> void:
	ammo_per_mag = max(1, apm)
	return
func get_ammo_per_mag() -> int:
	return ammo_per_mag
	
func set_max_mags(mags: int) -> void:
	max_mags = max(1, mags)
	return
func get_max_mags() -> int:
	return max_mags
	
func set_ammo(ammo: int) -> void:
	cur_ammo = max(0, min(ammo, ammo_per_mag))
	return	
func get_ammo() -> int:
	return cur_ammo
	
func set_mags(mags: int) -> void:
	cur_mags = max(0, min(mags, max_mags))
	return
func get_mags() -> int:
	return cur_mags
