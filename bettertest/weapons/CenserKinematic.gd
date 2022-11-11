extends KinematicBody

# change this out for a smoky  effect ? 
export var distance = 10000
var bodies_to_exclude = []
var speed = 80 
var directionToSend = Vector3()
var impact_damage = 20
var exploded = false
var return_censer = preload("res://weapons/ReturnCenserKinematic.tscn")

func _ready():
	hide()

func set_bodies_to_exclude(bodies_to_exclude: Array):
	bodies_to_exclude = bodies_to_exclude
	
	for body in bodies_to_exclude:
		add_collision_exception_with(body)


func _physics_process(delta):
	var collision = move_and_collide(directionToSend * speed * delta)
	
	if collision:
		var collider = collision.collider
		
		if collider.has_method("hurt"):
			collider.hurt(impact_damage, -global_transform.basis.z)
		
		explode()

func explode():
	# explode should begin recall of the kinematic body censer back towards the player as well before deletion
	if exploded:
		return
	exploded = true

	speed = 0 
	$CollisionShape.disabled = true
	$ChainTrail.emitting = false
	$Graphics.hide()
	
	# spawn the return censer
	var censer_inst = return_censer.instance()
	censer_inst.set_bodies_to_exclude(bodies_to_exclude)
	get_tree().get_root().add_child(censer_inst)
	censer_inst.global_transform = global_transform
	
	$DestroyAfterHitTimer.start()
