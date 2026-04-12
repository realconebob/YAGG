class_name BaseEntity
extends CharacterBody2D

signal collided(collider: KinematicCollision2D, collidee: BaseEntity)
signal damaged(this: BaseEntity)
signal died(this: BaseEntity)
signal healed(this: BaseEntity)
signal revived(this: BaseEntity)

var max_speed: float = 1200:
	get: return max_speed
	set(speed): max_speed = abs(speed)

var max_accel: float = 15000:
	get: return max_accel
	set(acc): max_accel = abs(acc)
	
var damping: float = 1.25:
	get: return damping
	set(damp): damping = max(1, abs(damp))

var max_health: float = 100:
	get: return max_health
	set(new_max):
		max_health = max(0, new_max)
		if max_health < health:
			health = max_health
		
var health: float = max_health:
	get: return health
	set(new_hp):
		var last_hp: float = health
		health = max(-1, min(new_hp, max_health))
		
		if health < last_hp:
			damaged.emit(self)
		if health <= 0.0 && alive:
			alive = false
			died.emit(self)
		if health > last_hp:
			healed.emit(self)
		if health > 0 && !alive:
			alive = true
			revived.emit(self)

var alive: bool = true:
	get: return alive
	set(state):
		if alive == state: return
		
		alive = state
		if state == true: health = max_health
		if state == false: health = -1

var accel: Vector2 = Vector2.ZERO:
	get: return accel
	set(acc): accel = acc.clamp(-max_accel * Vector2.ONE, max_accel * Vector2.ONE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity += Vector2(
		velocity.x * ((1/damping) - 1),
		velocity.y * ((1/damping) - 1),
	) + (delta * accel)
	
	velocity = velocity.clamp(
		-max_speed * Vector2.ONE, 
		max_speed * Vector2.ONE
	)
	
	var collider := move_and_collide(velocity * delta)
	if collider:
		collided.emit(collider, self)
	
	pass
	
func get_type() -> String:
	return "BaseEntity"
