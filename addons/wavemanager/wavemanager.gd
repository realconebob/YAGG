class_name WaveManager
extends Node

const def_wave_target: int = 70
const def_wave_difficulty_rate: float = def_wave_target * 0.5
const def_wave_difficulty_accel: float = def_wave_difficulty_rate * 0.25

var dp: Array = []
var parent: Array = []

@export_category("Wave Settings")
@export var increment_vals: Array[int] = []
@export var wave_target: int = def_wave_target							## zombies in a wave (z)
@export var wave_difficulty_rate: float = def_wave_difficulty_rate		## extra zombies per wave (z/w)
@export var wave_difficulty_accel: float = def_wave_difficulty_accel	## extra zombies per wave per wave (z/w^2)

func _run_point_calc(prefix:String, calculator: Callable) -> void:
	var res := calculator.call(increment_vals, wave_target)
	if len(res) != 3:
		print("%s - ERROR: result array indicates error in calculator function\n" % [prefix])
		return
	print(
		"%s\n"							% prefix +
		"\t> Increments used: %s\n"		% res[0] +
		"\t> Total increments: %d\n"	% res[1] +
		"\t> Remainder: %d\n"			% res[2]
	)
	return

func _ready() -> void:
	dp.append(0)
	parent.append(-1)
	return

# Not sure why this isn't working as expected
static func expand_array(arr: Array, size: int, fill_value: Variant) -> void:
	if not arr or size <= 0: return
	if size <= len(arr): return
	
	var err := arr.resize(size)
	if err != OK:
		print(err)
		return
	
	for i in range(len(arr), size):
		arr[i] = fill_value
	
	return


func update_wave_target(waves: int = 1) -> Array[float]:
	@warning_ignore("narrowing_conversion")
	wave_target += wave_difficulty_rate * waves
	wave_difficulty_rate += wave_difficulty_accel * waves

	return [wave_target, wave_difficulty_rate, wave_difficulty_accel]
	
# Finds locally optimal solutions, may not find the globally optimal solution (may find a solution, but one with too many point increments)
func greedy_point_solver(pointvals: Array[int], target: int) -> Array[Variant]:
	if target < 1 or not pointvals: 
		print("<WaveManager::greedy_point_solver> Error: %s%s" % [
			"target < 1 " if target < 1 else "",
			"pointvals is empty" if not pointvals else ""
		])
		return []
	
	var pointcpy: Array[int] = pointvals.duplicate()
	var count: Dictionary[int, int] = {}
	var total: int = 0

	if 0 in pointcpy: pointcpy.erase(0)
	pointcpy.sort()
	pointcpy.reverse()

	for i in range(0, len(pointcpy)):
		if target >= pointcpy[i]:
			@warning_ignore("integer_division")
			var tmp = target / pointcpy[i]
			
			total += tmp
			target -= tmp * pointcpy[i]
			count[pointcpy[i]] = tmp

		if target == 0:
			break

	return [count, total, target] # Point increment counts, total increments used, remainder if any
	
func dynamic_point_solver(pointvals: Array[int], target: int) -> Array[Variant]:
	if target < 1 or not pointvals: 
		print("<WaveManager::dynamic_point_solver> Error: %s%s" % [
			"target < 1 " if target < 1 else "",
			"pointvals is empty" if not pointvals else ""
		])
		return []

	var pointcpy: Array[int] = pointvals.duplicate()
	#var dp := []
	#var parent := []

	# Set up arrays
	if 0 in pointcpy: pointcpy.erase(0)
	pointcpy.sort()
	pointcpy.reverse()
	
	dp.resize(target + 1)
	for i in range(len(dp)):
		dp[i] = INF
	parent.resize(target + 1)
	for i in range(len(parent)):
		parent[i] = -1

	dp[0] = 0

	for i in range(1, target + 1):
		for pointval in pointcpy:
			if pointval <= i and dp[i - pointval] + 1 < dp[i]:
				dp[i] = dp[i - pointval] + 1
				parent[i] = pointval

	# Find the best reachable amount (exact or closest without going over)
	var best = 0
	for i in range(target, -1, -1):
		if dp[i] != INF:
			best = i
			break

	var remainder = target - best

	# Trace back which pointvals were used
	var used: Dictionary[int, int] = {}
	var current = best
	while current > 0:
		var pointval = parent[current]
		used[pointval] = used.get(pointval, 0) + 1
		current -= pointval

	var total = 0
	for value in used.values():
		total += value
	
	return [used, total, remainder]
