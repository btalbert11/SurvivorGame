extends Node

signal spawn_magic_missle
signal spawn_hammer
signal spawn_sword
signal spawn_spike

signal magic_missle_level_up
signal hammer_level_up
signal sword_level_up
signal spike_level_up

signal magic_max_level
signal hammer_max_level
signal sword_max_level
signal spike_max_level

var magic_text: String = "Upgrade Magic Missle\nIncrease fire rate"
var hammer_text: String = "Purchase Hammer"
var sword_text: String = "Purchase Sword"
var spike_text: String = "Purchase Throwing Spikes" 


func magic_missle_level():
	magic_missle_level_up.emit()
	get_tree().paused = false

func hammer_level():
	hammer_level_up.emit()
	get_tree().paused = false

func sword_level():
	sword_level_up.emit()
	get_tree().paused = false

func spike_level():
	spike_level_up.emit()
	get_tree().paused = false

func change_level_up_text(label: int, new_text: String):
	match label:
		0:
			magic_text = new_text
		1:
			hammer_text = new_text
		2:
			sword_text = new_text
		3:
			spike_text = new_text
		_:
			return
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
