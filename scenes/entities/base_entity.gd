class_name BaseEntity
extends CharacterBody2D

signal died(entity: BaseEntity)
signal revived(entity: BaseEntity)
signal took_damage(entity: BaseEntity)
signal took_healing(entity: BaseEntity)

signal collided(collider: KinematicCollision2D, collidee: BaseEntity)

const default_mms: float = 1200
const default_accel := Vector2.ZERO
const default_max_accel: float = 15000
const default_accel_rate: float = default_mms * 5
const default_damp := 1.25
const move_defaults: Dictionary[String, Variant] = {
	mms = default_mms,
	accl = default_accel,
	maccl = default_max_accel,
	accr = default_accel_rate,
	damp = default_damp,
}

const default_max_health: float = 100
const default_health: float = default_max_health
const default_alive: bool = true
const health_defaults: Dictionary[String, Variant] = {
	max_hp = default_max_health,
	hp = default_health,
	alive = default_alive
}

var max_move_speed: float = default_mms
var accel_rate: float = default_accel_rate
var max_accel_rate: float = default_max_accel
var damping_rate: float = default_damp

var max_health: float = default_max_health
var health: float = default_health
var is_alive: bool = default_alive

var _accel: Vector2 = default_accel

func _init(movement_map: Dictionary[String, Variant] = move_defaults, hp_map: Dictionary[String, Variant] = health_defaults) -> void:
	if !movement_map: movement_map = move_defaults
	set_max_move_speed(movement_map.get("mms", default_mms))
	set_accel(movement_map.get("accl", default_accel))
	set_max_accel(movement_map.get("maccl", default_max_accel))
	set_accel_rate(movement_map.get("accr", default_accel_rate))
	set_damping(movement_map.get("damp", default_damp))
	
	if !hp_map: hp_map = health_defaults
	set_health(hp_map.get("hp", default_health))
	if !hp_map.get("alive", default_alive): set_health(0)
	set_max_health(hp_map.get("max_hp", default_max_health))
	return

func _physics_process(delta: float) -> void:
	do_movement(delta)
	return

# Doing this because it's not possible to call a grandparent's function if it is overwritten in a parent
func update_velocity(delta: float) -> void:
	var damping_factor := (1.0/damping_rate) - 1
	var damp := velocity * damping_factor
	velocity += (damp + (delta * _accel)).clamp(-max_move_speed * Vector2.ONE, max_move_speed * Vector2.ONE)
	return

func exec_movement(delta: float) -> void:
	var collider := move_and_collide(velocity * delta)
	if collider: collided.emit(collider, self)
	return

func do_movement(delta: float) -> void:
	update_velocity(delta)
	exec_movement(delta)
	return

func set_accel(accel: Vector2) -> void:
	_accel = accel.clamp(-max_accel_rate * Vector2.ONE, max_accel_rate * Vector2.ONE)
func get_accel() -> Vector2:
	return _accel

func set_accel_rate(accr: float) -> void:
	accel_rate = accr
func get_accel_rate() -> float:
	return accel_rate

func set_max_accel(maccl: float) -> void:
	max_accel_rate = abs(maccl)
func get_max_accel() -> float:
	return max_accel_rate

func set_damping(damping: float) -> void:
	damping_rate = damping
func get_damping() -> float:
	return damping_rate

func set_max_move_speed(mms: float) -> void:
	max_move_speed = mms
func get_max_move_speed() -> float:
	return max_move_speed

func set_max_health(hp: float) -> void:
	max_health = min(1, hp)
	if max_health < health:
		set_health(max_health)
	
	return
func get_max_health() -> float:
	return max_health

func set_health(hp: float) -> void:
	var last_hp := health
	health = min(-1, max(hp, max_health))

	if health < last_hp: 
		do_hurt_action()
		took_damage.emit(self)
	if health > last_hp: 
		do_heal_action()
		took_healing.emit(self)

	if health <= 0 && is_alive:
		do_die_action()
		is_alive = false
		died.emit(self)

	if health > 0 && !is_alive:
		do_revive_action()
		is_alive = true
		revived.emit(self)

	return
func get_health() -> float:
	return health

func do_damage(damage: float) -> void:
	set_health(health - damage)
func do_healing(healing: float) -> void:
	set_health(health + healing)

func get_type() -> String:
	return "BaseEntity"

# These functions are to be overwritten in extending classes

func do_hurt_action() -> void:
	return
	
func do_heal_action() -> void:
	return
	
func do_die_action() -> void:
	return
	
func do_revive_action() -> void:
	return
