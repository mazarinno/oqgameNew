extends Spatial

var tornado = preload("res://weapons/Tornado.tscn")
var bodies_to_exclude = []
var damage = 1

func set_damage(_damage: int):
	damage = _damage
	
func set_bodies_to_exclude(_bodies_to_exclude: Array):
	bodies_to_exclude = _bodies_to_exclude
	
func fire():
	print("nado fired")
	var tornado_inst = tornado.instance()
	tornado_inst.set_bodies_to_exclude(bodies_to_exclude)
	get_tree().get_root().add_child(tornado_inst)
	tornado_inst.global_transform = global_transform
	tornado_inst.impact_damage = damage
