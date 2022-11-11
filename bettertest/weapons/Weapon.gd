extends Spatial

onready var anim_player = $AnimationPlayer
onready var fireball_emitters_base : Spatial = $FireballEmitters
onready var fireball_emitters = $FireballEmitters.get_children()
onready var graphics = $Graphics

export var automatic = false 

var fire_point : Spatial 
var bodies_to_exclude : Array = []
var censer = preload("res://weapons/CenserKinematic.tscn")

export var damage = 5
export var ammo = 30

export var attack_rate = 0.2
var attack_timer : Timer 
var can_attack = true

signal fired
signal out_of_ammo

func _ready():
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_rate
	attack_timer.connect("timeout", self, "finish_attack")
	attack_timer.one_shot = true
	add_child(attack_timer)
	
func init(_fire_point: Spatial, _bodies_to_exclude: Array):
	fire_point = _fire_point
	bodies_to_exclude = _bodies_to_exclude
	
	for fireball_emitter in fireball_emitters:
		fireball_emitter.set_damage(damage)
		fireball_emitter.set_bodies_to_exclude(bodies_to_exclude)

func attack(attack_input_just_pressed: bool, attack_input_held: bool):
	if !can_attack:
		return
	if automatic and !attack_input_held:
		return
	elif !automatic and !attack_input_just_pressed:
		return
	
	if ammo == 0:
		if attack_input_just_pressed:
			emit_signal("out_of_ammo") 
		return
	
	if ammo > 0:
		ammo -= 1
		
	var start_transform = fireball_emitters_base.global_transform
	fireball_emitters_base.global_transform = fire_point.global_transform
	
	for fireball_emitter in fireball_emitters:
		fireball_emitter.fire()
	
	fireball_emitters_base.global_transform = start_transform
	anim_player.stop()

	# flamethrower special case
	if anim_player.has_animation("beginattack") and attack_input_just_pressed:
		anim_player.play("beginattack")
	else:
		# if censer, hide graphics 
		if anim_player.has_animation("censer"):
			graphics.hide()
		anim_player.play("attack") 
		if anim_player.has_animation("beginattack"):
			var particles = $Graphics/Particles
			particles.emitting = true
	
	emit_signal("fired")
	can_attack = false
	attack_timer.start()
	
func finish_attack():
	# for the censer here do idle and show to graphics only if.. fireball emitters censer spawner has no current children?
	if anim_player.has_animation("censer"):
		anim_player.play("idle")
		graphics.show()
	if anim_player.has_animation("beginattack"):
		var particles = $Graphics/Particles
		particles.emitting = false
		anim_player.play("releaseattack")
	can_attack = true

func set_active():
	show()
	$Crosshair.show()
	
func set_inactive():
	anim_player.play("idle")
	hide()
	$Crosshair.hide()
	
func is_idle():
	return !anim_player.is_playing() or anim_player.current_animation == "idle"
