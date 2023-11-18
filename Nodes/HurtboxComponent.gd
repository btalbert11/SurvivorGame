class_name HurtboxComponent
extends Area2D

signal attacked(attack: Attack)

func take_attack(attack: Attack):
	attacked.emit(attack)
