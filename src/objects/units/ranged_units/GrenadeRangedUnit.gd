extends "res://src/objects/units/ranged_units/BasicRangedUnit.gd"


func _shoot_projectile():
	var targets = $CheckEnemies.get_overlapping_bodies()
	
	# shoot at middle target
	var index = floor(targets.size()/2.0)
	
	var new_projectile: PROJECTILE = projectile.instance()
	new_projectile.global_position = global_position
	get_parent().add_child(new_projectile)
	
	if targets.size() == 0: 
		new_projectile.shoot(attack_damage, _target_pos, sign(move_speed) == -1)
	else:
		new_projectile.shoot(attack_damage, targets[index].global_position, sign(move_speed) == -1)
