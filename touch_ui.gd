extends CanvasLayer

var joy_origin := Vector2(115, 590)
var joy_vector := Vector2.ZERO
var active_touch := -1
var joy_radius := 75.0

func _ready() -> void:
    set_process_input(true)
    queue_redraw()

func _input(event: InputEvent) -> void:
    var screen_size := get_viewport().get_visible_rect().size
    joy_origin = Vector2(115, screen_size.y - 115)

    if event is InputEventScreenTouch:
        if event.pressed and event.position.x < screen_size.x * 0.48 and active_touch == -1:
            active_touch = event.index
            _update_joystick(event.position)
        elif not event.pressed and event.index == active_touch:
            active_touch = -1
            joy_vector = Vector2.ZERO
            _set_actions()
            queue_redraw()
    elif event is InputEventScreenDrag and event.index == active_touch:
        _update_joystick(event.position)

func _update_joystick(pos: Vector2) -> void:
    joy_vector = (pos - joy_origin).limit_length(joy_radius) / joy_radius
    _set_actions()
    queue_redraw()

func _set_actions() -> void:
    Input.action_press("move_left", max(0.0, -joy_vector.x))
    Input.action_press("move_right", max(0.0, joy_vector.x))
    Input.action_press("move_forward", max(0.0, -joy_vector.y))
    Input.action_press("move_backward", max(0.0, joy_vector.y))
    if abs(joy_vector.x) < 0.05:
        Input.action_release("move_left")
        Input.action_release("move_right")
    if abs(joy_vector.y) < 0.05:
        Input.action_release("move_forward")
        Input.action_release("move_backward")

func _draw() -> void:
    var size := get_viewport().get_visible_rect().size
    joy_origin = Vector2(115, size.y - 115)
    draw_circle(joy_origin, joy_radius, Color(0.05, 0.08, 0.12, 0.35))
    draw_arc(joy_origin, joy_radius, 0, TAU, 48, Color(0.8, 0.9, 1, 0.55), 3.0)
    draw_circle(joy_origin + joy_vector * joy_radius, 28, Color(0.75, 0.85, 1, 0.65))
    draw_string(ThemeDB.fallback_font, Vector2(size.x - 115, size.y - 55), "MARINHO RP", HORIZONTAL_ALIGNMENT_CENTER, -1, 22, Color(1,1,1,0.8))
