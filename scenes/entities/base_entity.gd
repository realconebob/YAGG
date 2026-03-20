class_name BaseEntity
extends CharacterBody2D

signal died(entity: BaseEntity)
signal revived(entity: BaseEntity)
signal took_damage(entity: BaseEntity)
signal took_healing(entity: BaseEntity)

signal mac_collided(collider: KinematicCollision2D)
signal mas_collided(colliders: Array[KinematicCollision2D])
# must fight the urge to put a signal on every setter function

const default_mms: float = 1200
const default_accel := Vector2.ZERO
const default_accel_rate: float = default_mms * 5
const default_damp := 1.25
const default_sliding := false

const default_max_health: float = 100
const default_health: float = default_max_health
const default_alive: bool = true

var max_move_speed: float = default_mms
var accel_rate: float = default_accel_rate
var damping_rate: float = default_damp
var is_sliding: bool = default_sliding

var max_health: float = default_max_health
var health: float = default_health
var is_alive: bool = default_alive

var _accel: Vector2 = default_accel

@onready var mms_neg: Vector2
@onready var mms_pos: Vector2

func _init(mms: float = default_mms, accel: Vector2 = default_accel, accr: float = default_accel_rate, damping: float = default_damp, sliding: bool = default_sliding, max_hp: float = default_max_health, cur_hp: float = default_health, alive: bool = default_alive) -> void:
	set_max_move_speed(mms)
	set_accel(accel)
	set_accel_rate(accr)
	set_damping(damping)
	set_sliding(sliding)
	
	set_health(cur_hp)
	if !alive: set_health(0)
	set_max_health(max_hp)
	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mms_neg = Vector2(-max_move_speed, -max_move_speed)
	mms_pos = Vector2(max_move_speed, max_move_speed)
	return

func _physics_process(delta: float) -> void:
	do_movement(delta)
	return

# Doing this because it's not possible to call a grandparent's function if it is overwritten in a parent
func update_velocity(delta: float) -> void:
	var damping_factor := (1.0/damping_rate) - 1
	var damp := Vector2(
		velocity.x * damping_factor,
		velocity.y * damping_factor
	)

	velocity.x += (_accel.x * delta) + damp.x
	velocity.y += (_accel.y * delta) + damp.y
	velocity = velocity.clamp(mms_neg, mms_pos)
	return

func exec_movement(delta: float) -> void:
	if is_sliding: 
		move_and_slide()
		if get_slide_collision_count() > 0:
			var colliders: Array[KinematicCollision2D] = []
			for i in get_slide_collision_count():
				colliders.append(get_slide_collision(i))
			
			mas_collided.emit(colliders)
		
	else: 
		var collider := move_and_collide(velocity * delta)
		if collider: mac_collided.emit(collider)
	
	return

func do_movement(delta: float) -> void:
	update_velocity(delta)
	exec_movement(delta)
	return

func set_accel(accel: Vector2) -> void:
	_accel = accel

func get_accel() -> Vector2:
	return _accel

func set_accel_rate(accr: float) -> void:
	accel_rate = accr

func get_accel_rate() -> float:
	return accel_rate

func set_damping(damping: float) -> void:
	damping_rate = damping

func get_damping() -> float:
	return damping_rate

func set_max_move_speed(mms: float) -> void:
	max_move_speed = mms
	if is_node_ready():
		mms_neg = Vector2(-max_move_speed, -max_move_speed)
		mms_pos = Vector2(max_move_speed, max_move_speed)

func get_max_move_speed() -> float:
	return max_move_speed

func set_sliding(sliding: bool) -> void:
	is_sliding = sliding

func get_sliding() -> bool:
	return is_sliding

func set_max_health(hp: float) -> bool:
	if hp <= 0: return false
	max_health = hp
	if max_health < health:
		set_health(max_health)
	
	return true

func get_max_health() -> float:
	return max_health

func set_health(hp: float) -> void:
	var last_hp := health
	health = hp

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


# These functions are to be overwritten in extending classes

func do_hurt_action() -> void:
	return
	
func do_heal_action() -> void:
	return
	
func do_die_action() -> void:
	return
	
func do_revive_action() -> void:
	return
