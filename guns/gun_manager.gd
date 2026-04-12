class_name GunManager
extends Node2D

const available_gun_scenes := [
	preload("res://guns/pistol/pistol.tscn"),
	preload("res://guns/shotgun/shotgun.tscn")
]

var enabled_guns: Array[BaseGun] = [
	available_gun_scenes[0].instantiate(),
	available_gun_scenes[1].instantiate(),
]
	
var gunidx: int = -1:
	set(n):
		var last_gunidx := gunidx
		gunidx = max(0, min(n, len(enabled_guns) - 1))
		
		if gunidx != last_gunidx:
			enabled_guns[last_gunidx].visible = false
			enabled_guns[gunidx].visible = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var pointing: Line2D = Line2D.new()
	pointing.clear_points()
	pointing.add_point(Vector2.ZERO)
	pointing.add_point(Vector2(150, 0))
	pointing.default_color = Color(1, 0, 0)
	pointing.width = 3
	
	add_child(pointing)
	
	for gun in enabled_guns:
		gun.visible = false
		add_child(gun)
		
	gunidx = 0
	return

func fire(cash: float) -> bool:
	var cgun := get_current_gun()
	if cash - cgun.cost < 0: return false
	return cgun.fire()
	
func get_current_gun() -> BaseGun:
	return enabled_guns[gunidx]
