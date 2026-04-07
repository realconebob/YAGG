extends Node

# Each wave / round will have a "difficulty level", which is some integer. The manager will then spawn some number
# of zombies semi-randomly until all zombies have been spawned. Then the difficulty level is raised, and the cycle
# repeated

const zombie_types := {
	base = preload("res://entities/zombie/zombie.tscn"),
	berzerker = preload("res://entities/berzerker_zombie/berzerker_zombie.tscn"),
	shooter = preload("res://entities/shooter_zombie/shooter_zombie.tscn")
}

var wave_target: int = 20										## zombies in a wave (z)
var wave_difficulty_rate: float = wave_target * 0.5				## extra zombies per wave (z/w)
var wave_difficulty_accel: float = wave_difficulty_rate * 0.25	## extra zombies per wave per wave (z/w^2)

@onready var dp = []
@onready var parent = []

func _ready() -> void:
	dp[0] = 0

func update_wave_target(waves: int = 1) -> Array[int]:
	@warning_ignore("narrowing_conversion")
	wave_target += wave_difficulty_rate * waves
	wave_difficulty_rate += wave_difficulty_accel * waves

	return [wave_target, wave_difficulty_rate, wave_difficulty_accel]

func expand_array(arr: Array, size: int, fill_value: Variant) -> void:
	if not arr or size <= 0: return
	if size <= len(arr): return
	
	arr.resize(size)
	for i in range(len(arr), size):
		arr[i] = fill_value
	
	return

# Finds locally optimal solutions, may not find the globally optimal solution (may find a solution, but one with too many point increments)
func greedy_point_solver(pointvals: Array[int], target: int) -> Array[Variant]:
	if target < 1 or not pointvals:
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
		return []

	var pointcpy: Array[int] = pointvals.duplicate()

	# Set up arrays
	if 0 in pointcpy: pointcpy.erase(0)
	pointcpy.sort()
	pointcpy.reverse()
	expand_array(dp, target + 1, INF)
	expand_array(parent, target + 1, -1)

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
