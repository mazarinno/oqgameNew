extends KinematicBody

var hotkeys = {
	KEY_1: 0,
	KEY_2: 1,
	KEY_3: 2,
	KEY_4: 3,
	KEY_5: 4,
	KEY_6: 5,
	KEY_7: 6,
	KEY_8: 7,
	KEY_9: 8,
	KEY_0: 9
}

export var mouse_sens = 0.5

onready var camera = $Camera
onready var character_mover = $CharacterMover
onready var health_manager = $HealthManager
onready var weapon_manager = $Camera/WeaponManager
onready var pickup_manager = $PickupManager
var dead = false
var in_water = false
var in_lava = false
var water_level_height = 1
var head_submerged = false

func _ready():
	$"/root/Global".register_player(self)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	character_mover.init(self)
	
	pickup_manager.max_player_health = health_manager.max_health
	health_manager.connect("health_changed", pickup_manager, "update_player_health")
	pickup_manager.connect("got_pickup", weapon_manager, "get_pickup")
	pickup_manager.connect("got_pickup", health_manager, "get_pickup")
	health_manager.init()
	health_manager.connect("dead", self, "kill")
	weapon_manager.init($Camera/FirePoint, [self])

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
	if dead:
		return
	
	var move_vec = Vector3()
	if Input.is_action_pressed("move_forwards"):
		move_vec += Vector3.FORWARD	
	if Input.is_action_pressed("move_backwards"):
		move_vec += Vector3.BACK
	if Input.is_action_pressed("move_right"):
		move_vec += Vector3.RIGHT
	if Input.is_action_pressed("move_left"):
		move_vec += Vector3.LEFT
	character_mover.set_move_vec(move_vec)
	if Input.is_action_just_pressed("jump"):
		character_mover.jump()
		
	weapon_manager.attack(Input.is_action_just_pressed("attack"),
		Input.is_action_pressed("attack"))
		
	var depth = $SwimmingNotifier.get_depth()
	
	if in_water:
		set_swimming(true)
		if depth >= water_level_height:
			head_submerged = true
		elif depth < water_level_height:
			head_submerged = false
	elif !in_water:
		if depth != 2.0:
			set_swimming(false)
			head_submerged = false
			
	if in_lava:
		health_manager.hurt(5, self.global_transform.origin)

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sens * event.relative.x
		camera.rotation_degrees.x -= mouse_sens * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
	
	if event is InputEventMouseButton and event.pressed: 
		if event.button_index == BUTTON_WHEEL_DOWN:
			weapon_manager.switch_to_next_weapon()
		if event.button_index == BUTTON_WHEEL_UP:
			weapon_manager.switch_to_last_weapon()

func hurt(damage, dir):
	print("im hurt")
	health_manager.hurt(damage, dir)
	
func heal(amount):
	health_manager.heal(amount)

func set_swimming(set : bool):
	if set == true: 
		if character_mover.cur_state != character_mover.STATES.SWIM:
			character_mover.cur_state = character_mover.STATES.SWIM
	elif set == false:
		if character_mover.cur_state == character_mover.STATES.SWIM:
			character_mover.cur_state = character_mover.STATES.GROUND

func kill():
	dead = true
	character_mover.freeze()
