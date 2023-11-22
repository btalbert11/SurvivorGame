extends Node2D

@export var hammer_attack_scene: PackedScene
@export var fire_rate: float = 1.8
@export var damage: float = 4.0
@export var knockback: float = 1.0
var fire_timer = Timer
var attack: Attack


# Called when the node enters the scene tree for the first time.
func _ready():
	attack = Attack.new()
	attack.damage = damage
	attack.knockback = knockback


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hitbox_component_area_entered(area):
	fire()

func fire():
	var hammer_attack = hammer_attack_scene.instantiate()
	attack.origin = global_position
	hammer_attack.attack = attack
	TODO ADD LEFT RIGHT AND MAKE ART
#	add_child(hammer_attack)
	call_deferred("add_child", hammer_attack)
	disable_hitbox()
	set_timer()
	

func disable_hitbox():
	$HitboxComponent/CollisionShape2DLEFT.set_deferred("disabled", true)
	$HitboxComponent/CollisionShape2DRIGHT.set_deferred("disabled", true)

func enable_hitbox():
	$HitboxComponent/CollisionShape2DLEFT.set_deferred("disabled", false)
	$HitboxComponent/CollisionShape2DRIGHT.set_deferred("disabled", false)

func set_timer():
	fire_timer = Timer.new()
	fire_timer.wait_time = fire_rate
	fire_timer.one_shot = true
	fire_timer.autostart = false
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	add_child(fire_timer)
	fire_timer.start()
	
func _on_fire_timer_timeout():
	enable_hitbox()
