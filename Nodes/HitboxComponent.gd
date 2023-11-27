class_name HitboxComponent
extends Area2D

func disable():
	$CollisionShape2D.set_deferred("disabled", true)

func enable():
	$CollisionShape2D.set_deferred("disabled", false)
