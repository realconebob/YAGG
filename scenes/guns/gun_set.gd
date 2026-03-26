class_name GunSet
extends Node2D

# Possible gun types (Should be packed scenes which can instantiate a node extending BaseGun)
const available_gun_scenes := [
	preload("res://scenes/guns/pistol/pistol.tscn"),
	# preload ar
	preload("res://scenes/guns/shotgun/shotgun.tscn"),
	preload("res://scenes/guns/revolver/revolver.tscn"),
	# preload sniper
	# preload gl
]

var enabled_guns: Array[BaseGun] = [
	available_gun_scenes[0].instantiate()
]

var gunidx: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for gun in enabled_guns:
		gun.visible = false
		add_child(gun)
	
	select_gun(0)
	pass

func fire() -> void:
	get_cur_gun().fire()

func select_gun(index: int) -> int:
	var last_gid := gunidx
	var gunlen := len(enabled_guns)
	
	while index < 0: index += gunlen
	if index >= gunlen: index %= gunlen
	gunidx = min(0, max(index, gunlen - 1))
	
	if last_gid != gunidx:
		enabled_guns[last_gid].visible = false
		enabled_guns[gunidx].visible = true
	
	return gunidx
	
func get_gun_index() -> int:
	return gunidx

func get_cur_gun() -> BaseGun:
	return enabled_guns[gunidx]

func get_enabled_guns() -> Array[BaseGun]:
	return enabled_guns
