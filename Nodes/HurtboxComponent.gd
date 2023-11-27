class_name HurtboxComponent
extends Area2D

signal attacked(attack: Attack)

func take_attack(attack: Attack):
	attacked.emit(attack)

func disable():
	$CollisionShape2D.set_deferred("disabled", true)

func enable():
	$CollisionShape2D.set_deferred("disabled", false)
