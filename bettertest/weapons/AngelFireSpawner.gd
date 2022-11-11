extends Spatial

var angelfire = preload("res://weapons/AngelFire.tscn")
var bodies_to_exclude = []
var damage = 1

func set_damage(_damage: int):
	damage = _damage
	
func set_bodies_to_exclude(_bodies_to_exclude: Array):
	bodies_to_exclude = _bodies_to_exclude
	
func fire():
	var angelfire_inst = angelfire.instance()
	angelfire_inst.set_bodies_to_exclude(bodies_to_exclude)
	get_tree().get_root().add_child(angelfire_inst)
	angelfire_inst.global_transform = global_transform
	angelfire_inst.impact_damage = damage
