extends "res://src/objects/units/ranged_units/BasicRangedUnit.gd"


func _shoot_projectile():
	var targets = $CheckEnemies.get_overlapping_bodies()
	if targets.size() == 0: return
	
	# shoot at middle target
	var index = floor(targets.size()/2.0)
	
	var new_projectile: PROJECTILE = projectile.instance()
	new_projectile.global_position = global_position
	get_parent().add_child(new_projectile)
	new_projectile.shoot(attack_damage, targets[index], sign(move_speed) == -1)
