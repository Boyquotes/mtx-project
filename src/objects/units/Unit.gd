extends KinematicBody2D

export var move_speed = 100
export var attack_cooldown = 1.0;
export var attack_damage = 1
export var max_health_points = 10;

onready var _initial_hp_bar_size = $ColorRect.rect_size.x

var _is_attacking = false
var _current_health_points = max_health_points

func _ready():
	$AttackCooldown.one_shot = true


func set_ally_or_enemy(is_ally: bool):
	if is_ally:
		set_collision_layer_bit(2, true)
		$CheckEnemies.set_collision_mask_bit(3, true)
		$CheckForAlliesInFront.set_collision_mask_bit(2, true)
	else:
		set_collision_layer_bit(3, true)
		$CheckEnemies.set_collision_mask_bit(2, true)
		$CheckForAlliesInFront.set_collision_mask_bit(3, true)
		$ColorRect.color = Color.red
		move_speed *= -1
		scale.x *= -1
		
func _start_attack():
	_is_attacking = true
	$AttackCooldown.start(attack_cooldown)
	_attack()
	
func _attack():
	pass

func _physics_process(delta):
	if _is_attacking: return
	
	if $CheckEnemies.get_overlapping_bodies().size() != 0:
		_start_attack()
	elif not $CheckForAlliesInFront.get_collider() is UnitTypes.UNIT_TYPE:
		move_and_slide(Vector2(move_speed, 0))

func _deal_damage():
	var targets = $CheckEnemies.get_overlapping_bodies()
	if targets.size() > 0:
		targets[0].take_damage(attack_damage)
	
func _on_AttackCooldown_timeout():
	_is_attacking = false

func take_damage(damage):
	print(damage)
	_current_health_points -= damage
	$ColorRect.rect_size = Vector2(_current_health_points * (_initial_hp_bar_size/max_health_points), $ColorRect.rect_size.y)
	if _current_health_points <= 0:
		queue_free()
