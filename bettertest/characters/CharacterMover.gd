extends Spatial

var body_to_move : KinematicBody = null

export var move_accel = 4
export var swim_accel = 2
export var max_speed = 25
export var max_swim_speed = 15
var drag = 0.0
var swim_drag = 0.0
export var jump_force = 30
export var swim_jump_force = 15
export var gravity = 60

var pressed_jump = false
var move_vec : Vector3
var velocity : Vector3
var snap_vec : Vector3
export var ignore_rotation = false

enum STATES {GROUND, SWIM}
var cur_state = STATES.GROUND

signal movement_info

var frozen = false

func _ready():
	drag = float(move_accel) / max_speed
	swim_drag = float(swim_accel) / max_swim_speed
	set_state_ground()

func init(_body_to_move: KinematicBody):
	body_to_move = _body_to_move

func jump():
	pressed_jump = true

func set_move_vec(_move_vec: Vector3):
	move_vec = _move_vec.normalized()

func _process(delta):
	match cur_state:
		STATES.GROUND:
			process_state_ground(delta)
		STATES.SWIM:
			process_state_swim(delta)

func set_state_ground():
	cur_state = STATES.GROUND

func set_state_swim():
	cur_state = STATES.SWIM

func process_state_ground(delta):
	if frozen:
		return
	var cur_move_vec = move_vec
	if !ignore_rotation:
		cur_move_vec = cur_move_vec.rotated(Vector3.UP, body_to_move.rotation.y)
	velocity += move_accel * cur_move_vec - velocity * Vector3(drag, 0, drag) + gravity * Vector3.DOWN * delta
	velocity = body_to_move.move_and_slide_with_snap(velocity, snap_vec, Vector3.UP)
	
	var grounded = body_to_move.is_on_floor()
	if grounded:
		velocity.y = -0.01
	if grounded and pressed_jump:
		velocity.y = jump_force
		snap_vec = Vector3.ZERO
	else:
		snap_vec = Vector3.DOWN
	pressed_jump = false
	emit_signal("movement_info", velocity, grounded)

func process_state_swim(delta):
	# same as grounded but jump moves up and fall not holding
	
	if frozen:
		return
	var cur_move_vec = move_vec
	if !ignore_rotation:
		cur_move_vec = cur_move_vec.rotated(Vector3.UP, body_to_move.rotation.y)
	velocity += swim_accel * cur_move_vec - velocity * Vector3(swim_drag, 0, swim_drag) + (gravity / 2) * Vector3.DOWN * delta
	velocity = body_to_move.move_and_slide_with_snap(velocity, snap_vec, Vector3.UP)
	
	if pressed_jump:
		velocity.y = swim_jump_force
		snap_vec = Vector3.ZERO
	
	emit_signal("movement_info", velocity, false)

func freeze():
	frozen = true

func unfreeze():
	frozen = false

