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
	
	# Just checking that zombie spawning actually works
	var vsize = get_viewport_rect().size
	for zombie in waveman.spawn_wave(WaveManager.WaveCalcType.DYNAMIC):
		zombie.collided.connect(chandler.handle_collision)
		zombie.died.connect(_kill)
		zombie.position = Vector2(randf_range(0, vsize.x), randf_range(0, vsize.y))
		add_child(zombie)
		zombies.append(zombie)
		
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
