extends BasicZombie

const bzkzomb_dmms: float = bzomb_dmms / 2
const bzkzomb_dacc: Vector2 = Vector2.ZERO
const bzkzomb_dacr: float = default_mms * 10
const bzkzomb_ddmp: float = 1.5

const bzkzomb_dcms: float = bzkzomb_dmms * 10
const bzkzomb_dcrg: float = 0.01
const bzkzomb_dcri: float = 0.03 # Percent per second more likely to charge assuming charge failed last phys frame
const bzkzomb_dtmr: float = 15.0 # Cooldown timer
const bzkzomb_dctmr: float = 3.0 # Charge timer

# Percent chance that the zombie charges
var charge_chance: float = bzkzomb_dcrg

@onready var charge_cooldown_timer: Timer = $ChargeCooldownTimer
@onready var charge_timer: Timer = $ChargeTimer
@onready var is_charge_ready: bool = true
@onready var is_charging: bool = false

func _init() -> void:
	super(bzkzomb_dmms, bzkzomb_dacc, bzkzomb_dacr, bzkzomb_ddmp)
	return

func _ready() -> void:
	charge_cooldown_timer.timeout.connect(process_charge_cooldown_timer)
	charge_timer.timeout.connect(process_charge_timer)
	return

func _physics_process(delta: float) -> void:
	# If the player is directly visible, and the charge timer is free, and a charge chance check is reached
	# charge at the player. Otherwise, move towards them like a basic zombie

	if is_target_visible() and is_charge_ready and !is_charging:
		var check := randf()
		if check <= charge_chance:
			is_charging = true
			is_charge_ready = false
			charge_timer.start(bzkzomb_dctmr)
			charge_cooldown_timer.start(bzkzomb_dtmr)
			charge_chance = bzkzomb_dcrg
		else: charge_chance += bzkzomb_dcri * delta

	if is_charging:
		# do charge
		pass

	do_movement(delta)
	return

func is_target_visible() -> bool:
	assert(false, "<berzerker_zombie::is_target_visible> Error: This function has not been implemented")
	return false

# Called when charge timer times-out
func process_charge_cooldown_timer() -> void:
	is_charge_ready = true
	return

func process_charge_timer() -> void:
	is_charging = false
	return

func set_target(trgt: Vector2) -> void:
	if is_charging: return
	super.set_target(trgt)
