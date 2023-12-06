class_name Levels
extends Node


func get_level_time(level: int) -> float:
	match level:
		1:
			return 15
		2:
			return 15
		3:
			return 20
		4:
			return 20
		5:
			return 20
		6:
			return 25
		7:
			return 30
		8:
			return 30
		9:
			return 30
		10:
			return 30
		11:
			return 30
		12:
			return 30
		13:
			return 30
		_:
			return 30

func get_spawn_rates(level: int) -> Array:
	# Array is in the form [blox_spawn_rate, dash_spawn_rate, bounce_spawn_rate, big_spawn_rate]
	var arr = []
	match level:
		1:
			arr = [3, 0, 0, 0]
		2:
			arr = [3.6, 0.3, 0, 0]
		3:
			arr = [4, 0.4, 0, 0]
		4:
			arr = [4.2, 0.5, 0, 0]
		5:
			arr = [4.6, 0.5, 0.2, 0]
		6:
			arr = [4.8, 0.6, 0.2, 0]
		7:
			arr = [5, 0.7, 0.3, 0]
		8:
			arr = [5, 0.8, 0.3, 0.1]
		9:
			arr = [5.2, 0.9, 0.4, 0.1]
		10:
			arr = [5.8, 1.5, 0.6, 0.15]
		11:
			arr = [6.3, 1.7, 0.8, 0.15]
		12:
			arr = [7, 1.8, 0.8, 0.2]
		13:
			arr = [8, 2, 1, 0.25]
		14:
			arr = [10, 4, 1.5, 0.4]
		15:
			arr = [10, 4, 1.5, 0.4]
		16:
			arr = [10, 4, 1.5, 0.4]
		17:
			arr = [10, 4, 1.5, 0.4]
		18:
			arr = [10, 4, 1.5, 0.4]
		19:
			arr = [10, 4, 1.5, 0.4]
		20:
			arr = [40, 15, 13, 5]
		_:
			arr = [40, 15, 13, 5]
	return arr
