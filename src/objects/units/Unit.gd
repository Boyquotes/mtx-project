extends KinematicBody2D

export var move_speed = 100
export var attack_cooldown = 1.0;
export var attack_damage = 1
export var max_health_points = 10;

onready var _initial_hp_bar_size = $ColorRect.rect_size.x

var _is_attacking = false
var _current_health_points 

# INITIALIZING
func _ready():
	$AttackCooldown.one_shot = true
	_current_health_points = max_health_points

# MOVEMENT
func _physics_process(delta):
	if _is_attacking: return
	if _can_attack():
		_start_attack()
	elif not $CheckForAlliesInFront.get_collider() is UnitTypes.UNIT_TYPE:
		move_and_slide(Vector2(move_speed, 0))

# COMBAT
func _deal_damage():
	if _can_attack():
		_find_closest_target().take_damage(attack_damage)
	
func _on_AttackCooldown_timeout():
	_is_attacking = false

func take_damage(damage):
	_current_health_points -= damage
	$ColorRect.rect_size = Vector2(_current_health_points * (_initial_hp_bar_size/max_health_points), $ColorRect.rect_size.y)
	if _current_health_points <= 0:
		queue_free()

func _start_attack():
	_is_attacking = true
	$AttackCooldown.start(attack_cooldown)
	_attack()
	
func _attack():
	pass
	
# UTILITY
func _can_attack():
	return $CheckEnemies.get_overlapping_bodies().size() != 0

func _find_closest_target():
	var target
	var min_distance = 100000
	for unit in $CheckEnemies.get_overlapping_bodies():
		var distance = unit.global_position.x - global_position.x
		if distance < min_distance:
			target = unit
	return target

# UNIT SIDES
func make_unit_ally():
	set_collision_layer_bit(2, true)
	set_collision_layer_bit(3, false)
	$CheckEnemies.set_collision_mask_bit(3, true)
	$CheckEnemies.set_collision_mask_bit(2, false)
	$CheckForAlliesInFront.set_collision_mask_bit(2, true)
	$CheckForAlliesInFront.set_collision_mask_bit(3, false)
	$ColorRect.color = Color.green
	move_speed = abs(move_speed)
	scale.x = abs(scale.x)

	
func make_unit_enemy():
	set_collision_layer_bit(3, true)
	set_collision_layer_bit(2, false)
	$CheckEnemies.set_collision_mask_bit(2, true)
	$CheckEnemies.set_collision_mask_bit(3, false)
	$CheckForAlliesInFront.set_collision_mask_bit(3, true)
	$CheckForAlliesInFront.set_collision_mask_bit(2, false)
	$ColorRect.color = Color.red
	move_speed = abs(move_speed) * -1
	scale.x = abs(scale.x) * -1

		
func switch_sides():
	if move_speed >= 0:
		make_unit_enemy()
	else:
		make_unit_ally()
	scale.x *= -1

