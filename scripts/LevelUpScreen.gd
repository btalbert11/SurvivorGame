extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$MagicUpgrade.button_down.connect(PlayerData.magic_missle_level)
	$HammerUpgrade.button_down.connect(PlayerData.hammer_level)
	$SwordUpgrade.button_down.connect(PlayerData.sword_level)
	$SpikeUpgrade.button_down.connect(PlayerData.spike_level)
	
	$MagicUpgrade.button_down.connect(_on_all_buttons_down)
	$HammerUpgrade.button_down.connect(_on_all_buttons_down)
	$SwordUpgrade.button_down.connect(_on_all_buttons_down)
	$SpikeUpgrade.button_down.connect(_on_all_buttons_down)
	
	PlayerData.magic_max_level.connect(_on_magic_max_level)
	PlayerData.hammer_max_level.connect(_on_hammer_max_level)
	PlayerData.sword_max_level.connect(_on_sword_max_level)
	PlayerData.spike_max_level.connect(_on_spike_max_level)
	


func _on_magic_max_level():
	$MagicUpgrade.visible = false
	$MagicUpgrade.process_mode = Node.PROCESS_MODE_DISABLED
	
func _on_hammer_max_level():
	$HammerUpgrade.visible = false
	$HammerUpgrade.process_mode = Node.PROCESS_MODE_DISABLED
	
func _on_sword_max_level():
	$SwordUpgrade.visible = false
	$SwordUpgrade.process_mode = Node.PROCESS_MODE_DISABLED
	
func _on_spike_max_level():
	$SpikeUpgrade.visible = false
	$SpikeUpgrade.process_mode = Node.PROCESS_MODE_DISABLED

func _on_all_buttons_down():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
