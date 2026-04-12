extends Node2D

const ColHandler := preload("res://battlegrounds/collision_handler.gd")
@onready var chandler := ColHandler.new()

const BasicZombie := preload("res://entities/zombie/zombie.tscn")

@onready var waveman: WaveManager = WaveManager.new()
@onready var zombies: Array[BaseEntity] = []
@onready var player := $Player

func _ready() -> void:
	for gun in (player.gunset as GunManager).enabled_guns:
		gun.fired.connect(_handle_bullets)

	waveman.increment_vals = [1]
	waveman.inc_map = {1: func() -> BaseEntity: return BasicZombie.instantiate()}
		
	player.collided.connect(chandler.handle_collision)
	player.died.connect(_kill)
	for zombie in waveman._spawn_wave([1], 20, {1: func() -> BaseEntity: return BasicZombie.instantiate()}, waveman.dynamic_point_solver):
		zombie.collided.connect(chandler.handle_collision)
		zombie.died.connect(_kill)
		
	return

func _physics_process(_delta: float) -> void:
	for zombie in zombies:
		if zombie != null && player != null:
			zombie.target = player.position

func _handle_bullets(bullets: Array[BaseEntity]) -> void:
	for bullet in bullets:
		bullet.collided.connect(chandler.handle_collision)
		bullet.died.connect(_kill)
		add_child(bullet)
	
	return
	
func _kill(p: BaseEntity) -> void:
	p.queue_free()
	print("%s died" % p.get_type())
