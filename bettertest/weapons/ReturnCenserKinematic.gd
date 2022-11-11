extends KinematicBody

# change this out for a smoky  effect ? 
export var distance = 10000
var bodies_to_exclude = []
var speed = 80 
var directionToSend = Vector3()
var vel = Vector3()
var exploded = false

func _ready():
	hide()

func set_bodies_to_exclude(bodies_to_exclude: Array):
	bodies_to_exclude = bodies_to_exclude
	
	for body in bodies_to_exclude:
		add_collision_exception_with(body)


func _physics_process(delta):
	# garbaj movement try
	var player = $"/root/Global".player.global_transform.origin
	
	# make this a little less so it can get closer to player
	if player.distance_to(transform.origin) > 3:
		directionToSend = player - transform.origin
		directionToSend = directionToSend.normalized() * speed
	else:
		directionToSend = player - transform.origin
		explode()
	
	move_and_slide(directionToSend)

func explode():
	# explode should begin recall of the kinematic body censer back towards the player as well before deletion
	if exploded:
		return
	exploded = true

	speed = 0 
	$CollisionShape.disabled = true
	$Graphics.hide()
	$DestroyAfterHitTimer.start()
