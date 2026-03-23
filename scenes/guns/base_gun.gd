class_name BaseGun
extends Node2D

signal fired(bullets: Array[BaseEntity], bullets_left: int)
signal reloaded(mags_left: int)

var bullet_scene: PackedScene
var bullet_cooldown: float = 0.3
var reload_duration: float = 1.5

var ammo_per_mag: int
var max_mags: int
var cur_ammo: int
var cur_mags: int

@onready var bullet_timer: SceneTreeTimer
@onready var reload_timer: SceneTreeTimer

func _init(bs: PackedScene = null, bc: float = 0.3, rd: float = 1.5, apm: int = 12, mm: int = 6, ca: int = apm, cm: int = mm) -> void:
	set_bullet_scene(bs)
	set_bullet_cooldown(bc)
	set_reload_duration(rd)
	set_ammo_per_mag(apm)
	set_max_mags(mm)
	set_ammo(ca)
	set_mags(cm)
	return

func create_bullets() -> Array[BaseEntity]:
	assert(false, "<BaseGun::instance_bullets> Error: This function is to be overwritten")
	return []

func get_gun_sprite() -> AnimatedSprite2D:
	assert(false, "<BaseGun::get_gun_sprite> Error: This function is to be overwritten")
	return null

func get_barrel_end() -> Node2D:
	assert(false, "<BaseGun::get_barrel_end> Error: This function is to be overwritten")
	return null

func get_hand_hold() -> Node2D:
	assert(false, "<BaseGun::get_hand_hold> Error: This function is to be overwritten")
	return null

func fire() -> void:
	if !bullet_scene or bullet_timer or reload_timer or cur_ammo <= 0 : return
	set_ammo(cur_ammo - 1)
	bullet_timer = get_tree().create_timer(bullet_cooldown, false, true)
	fired.emit(create_bullets(), cur_ammo)

func reload() -> void:
	if reload_timer or cur_ammo == ammo_per_mag or cur_mags <= 0: return
	set_mags(cur_mags - 1)
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
