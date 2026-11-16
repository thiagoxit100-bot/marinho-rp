extends CharacterBody3D

@export var move_speed: float = 5.0
@export var gravity: float = 18.0

func _physics_process(delta: float) -> void:
    var input_dir := Vector2.ZERO
    input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    input_dir.y = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")

    # Touch joystick writes to these virtual actions; keyboard is useful for desktop testing.
    if input_dir.length() > 1.0:
        input_dir = input_dir.normalized()

    var direction := Vector3(input_dir.x, 0.0, input_dir.y)
    if direction.length() > 0.01:
        direction = direction.rotated(Vector3.UP, $CameraPivot.rotation.y)
        velocity.x = direction.x * move_speed
        velocity.z = direction.z * move_speed
        $BodyMesh.rotation.y = atan2(-direction.x, -direction.z)
    else:
        velocity.x = move_toward(velocity.x, 0.0, move_speed)
        velocity.z = move_toward(velocity.z, 0.0, move_speed)

    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        velocity.y = 0.0

    move_and_slide()
