@tool
extends VBoxContainer

const def_target: int = 20
const def_rate: int = def_target * 0.25
const def_accel: float = def_rate * 0.25

@onready var waveman: WaveManager
@onready var wtspin: SpinBox = $PanelContainer/CenterContainer/GridContainer/WTSpinBox
@onready var wrspin: SpinBox = $PanelContainer/CenterContainer/GridContainer/WRSpinBox
@onready var waspin: SpinBox = $PanelContainer/CenterContainer/GridContainer/WASpinBox
@onready var tbutton: Button = $PanelContainer2/VBoxContainer/UWaveTargets
@onready var gbutton: Button = $PanelContainer2/VBoxContainer/Greedy
@onready var dbutton: Button = $PanelContainer2/VBoxContainer/Dynamic
@onready var rwtbutton: Button = $PanelContainer/CenterContainer/GridContainer/WTReset
@onready var rwrbutton: Button = $PanelContainer/CenterContainer/GridContainer/WRReset
@onready var rwabutton: Button = $PanelContainer/CenterContainer/GridContainer/WAReset

@onready var sspin: SpinBox = $PanelContainer3/CenterContainer/SlotsContainer/HBoxContainer/NumSlots

@onready var target := def_target:
	get: return target
	set(nt): 
		target = max(0, nt)
		waveman.wave_target = target
		if wtspin.value != target:
			wtspin.value = target

@onready var rate := def_rate:
	get: return rate
	set(nr): 
		rate = max(0, nr)
		waveman.wave_difficulty_rate = rate
		if wrspin.value != rate:
			wrspin.value = rate

@onready var accel := def_accel:
	get: return accel
	set(na): 
		accel = max(0, na)
		waveman.wave_difficulty_accel = accel
		if waspin.value != accel:
			waspin.value = accel

var is_setup: bool = false

func _ready() -> void:
	var wavebtn := make_separator_button("Wave Values")
	add_child(wavebtn)
	move_child(wavebtn, 0)
	
	var opsbtn := make_separator_button("Wave Operations")
	add_child(opsbtn)
	move_child(opsbtn, 2)
	
	var inptbtn := make_separator_button("Point Values")
	add_child(inptbtn)
	move_child(inptbtn, 4)
	
	waveman = WaveManager.new()
	add_child(waveman)
	
	wtspin.value_changed.connect(func(n: float) -> void: target = n)
	wrspin.value_changed.connect(func(n: float) -> void: rate = n)
	waspin.value_changed.connect(func(n: float) -> void: accel = n)
	wtspin.value = def_target
	wrspin.value = def_rate
	waspin.value = def_accel
	# I think these cause an infinite signal spiral but it seems to not be a problem so I'm not going to inspect it any closer
	
	tbutton.pressed.connect(
		func() -> void: 
			var res := waveman.update_wave_target()
			print(res)
			target = res[0]
			rate = res[1]
			accel = res[2]
	)
	
	gbutton.pressed.connect(func() -> void: waveman._run_point_calc("Greedy", waveman.greedy_point_solver))
	dbutton.pressed.connect(func() -> void: waveman._run_point_calc("Dynamic", waveman.dynamic_point_solver))

	rwtbutton.pressed.connect(func() -> void: target = def_target)
	rwrbutton.pressed.connect(func() -> void: rate = def_rate)
	rwabutton.pressed.connect(func() -> void: accel = def_accel)

	sspin.value_changed.connect(do_slots)

func _process(_delta: float) -> void:
	queue_redraw()
	return

func make_separator_button(label: String= "", icon: Texture2D = null) -> Button:
	var btn := Button.new()
	btn.text = label
	if icon:
		btn.icon = icon
	
	btn.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.focus_mode = Control.FOCUS_NONE
	btn.flat = false
	btn.alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	var style = get_theme_stylebox("prop_category", "EditorInspector").duplicate()
	style.border_width_top = 0
	style.border_width_bottom = 0
	style.border_width_left = 0
	style.border_width_right = 0
	
	btn.add_theme_stylebox_override("normal", style)
	
	return btn

@onready var old: float = 0
var bs: Array[Variant] = []
var vals: Array[int] = []
func do_slots(n: int) -> void:
	if n < old:
		for i in range(bs.size() - 1, n - 1, -1):
			$PanelContainer3/CenterContainer/SlotsContainer.remove_child(bs[i])
			bs[i].queue_free()
			bs[i] = null
		bs.resize(n)
		vals.resize(n)
	
	if n > old:
		var prior := bs.size()
		bs.resize(n)
		vals.resize(n)
		for i in range(prior, n):
			bs[i] = _new_bs_sb(n)
			$PanelContainer3/CenterContainer/SlotsContainer.add_child(bs[i])
	
	old = n
	return

func _new_bs_label(n: int) -> Label:
	var res := Label.new()
	res.text = "Entry %d" % n
	return res

func _new_bs_sb(n: int) -> SpinBox:
	var res := SpinBox.new()
	res.allow_greater = true
	res.step = 1
	res.rounded = true
	res.value_changed.connect(
		func(f: float) -> void:
			vals[n - 1] = f
			waveman.increment_vals = vals.duplicate()
	)
	return res
