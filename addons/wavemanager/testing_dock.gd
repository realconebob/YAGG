@tool
extends VBoxContainer

@onready var waveman: WaveManager
@onready var wtspin: SpinBox = $PanelContainer/CenterContainer/GridContainer/WTSpinBox
@onready var wrspin: SpinBox = $PanelContainer/CenterContainer/GridContainer/WRSpinBox
@onready var waspin: SpinBox = $PanelContainer/CenterContainer/GridContainer/WASpinBox
@onready var tbutton: Button = $PanelContainer2/VBoxContainer/UWaveTargets
@onready var gbutton: Button = $PanelContainer2/VBoxContainer/Greedy
@onready var dbutton: Button = $PanelContainer2/VBoxContainer/Dynamic

@onready var target := wtspin.value:
	get: return target
	set(nt): 
		target = max(0, nt)
		waveman.wave_target = target
		wtspin.value = target

@onready var rate := wrspin.value:
	get: return rate
	set(nr): 
		rate = max(0, nr)
		waveman.wave_difficulty_rate = rate
		wrspin.value = rate

@onready var accel := waspin.value:
	get: return accel
	set(na): 
		accel = max(0, na)
		waveman.wave_difficulty_accel = accel
		waspin.value = accel

var is_setup: bool = false

func _ready() -> void:
	var wavebtn := make_separator_button("Wave Values")
	add_child(wavebtn)
	move_child(wavebtn, 0)
	
	var opsbtn := make_separator_button("Wave Operations")
	add_child(opsbtn)
	move_child(opsbtn, 2)
	
	waveman = WaveManager.new()
	add_child(waveman)
	
	wtspin.value_changed.connect(func(n: float) -> void: target = n)
	wrspin.value_changed.connect(func(n: float) -> void: rate = n)
	waspin.value_changed.connect(func(n: float) -> void: accel = n)
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
