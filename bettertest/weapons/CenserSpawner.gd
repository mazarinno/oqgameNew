extends Spatial

var censer = preload("res://weapons/CenserKinematic.tscn")
var bodies_to_exclude = []
var damage = 1

func set_damage(_damage: int):
	damage = _damage
	
func set_bodies_to_exclude(_bodies_to_exclude: Array):
	bodies_to_exclude = _bodies_to_exclude
	
func fire():
	var censer_inst = censer.instance()
	censer_inst.set_bodies_to_exclude(bodies_to_exclude)
	get_tree().get_root().add_child(censer_inst)
	censer_inst.global_transform = global_transform
	censer_inst.directionToSend = -global_transform.basis.z
	censer_inst.impact_damage = damage
	
