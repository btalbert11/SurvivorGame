extends CharacterBody2D


@export var SPEED: float = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * SPEED
	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#		velocity.y = move_toward(velocity.y, 0, SPEED)
		velocity = Vector2.ZERO
	move_and_slide()
