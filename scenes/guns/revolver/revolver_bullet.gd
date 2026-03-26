extends BaseEntity

const pbul_mms: float = 10000
const pbul_acr: float = 10000
const pbul_dmp: float = 0

func _init() -> void:
	super({mms = pbul_mms, accr = pbul_acr, damp = pbul_dmp}, {max_hp = 5})
	return

func _ready() -> void:
	$Sprite.play(&"default")
	return

func _physics_process(delta: float) -> void:
	exec_movement(delta)
	pass
