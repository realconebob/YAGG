@tool
extends EditorPlugin

const testing_dock := preload("res://addons/wavemanager/testing_dock.tscn")
var dock_storage

func _enable_plugin() -> void:
	# Add autoloads here.
	add_custom_type("WaveManager", "Node", preload("wavemanager.gd"), preload("res://assets/icon.svg"))
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	remove_custom_type("WaveManager")
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	dock_storage = EditorDock.new()
	dock_storage.add_child(testing_dock.instantiate())
	dock_storage.title = "Wave Testing"
	dock_storage.default_slot = EditorDock.DOCK_SLOT_LEFT_UL
	dock_storage.available_layouts = EditorDock.DOCK_LAYOUT_VERTICAL | EditorDock.DOCK_LAYOUT_FLOATING
	
	add_dock(dock_storage)
	return


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_dock(dock_storage)
	dock_storage.queue_free()
	pass
