extends Spatial

onready var guided_objet = self
onready var camera = get_parent().get_node("Camera")
onready var body = get_parent() 
onready var depth_sense : RayCast = $depth_sense
onready var lava_area : Area = $lava_area

var depth : float = 0.0

func _process(delta):
	body.in_lava = bool(lava_area.get_overlapping_areas().size())
	
	depth = to_local(depth_sense.get_collision_point()).y
	
	if body.in_lava and !depth_sense.is_colliding():
		depth = 2.0
	elif !body.in_lava and !depth_sense.is_colliding():
		depth = 0.0

func get_depth():
	return depth
