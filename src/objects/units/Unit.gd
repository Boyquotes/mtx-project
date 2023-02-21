extends KinematicBody2D

const DEATH_TEXT_SCENE = preload("res://src/scenes/battle_scene/DeathText.tscn")

export var move_speed = 100
export var attack_damage = 1
export var max_health_points = 10;
export var cost = 100;

export var min_money_on_death = 10;
export var max_money_on_death = 100;

export var no_collision_with_allies = false

onready var _initial_hp_bar_size = $ColorRect.rect_size.x

var _current_health_points 
var _dead = false

# INITIALIZING
func _ready():
	$AttackCooldown.one_shot = true
	_current_health_points = max_health_points
	
# STATE MACHINE
func _take_action():
	if _enemy_in_range():
		if $AnimatedSprite.animation != "attack": 
			set_physics_process(false)
			$AnimatedSprite.play("attack")
	elif _check_for_ally_in_front():
		if $AnimatedSprite.animation != "idle": 
			$AnimatedSprite.play("idle")
	else:
		if $AnimatedSprite.animation != "move": 
			$AnimatedSprite.play("move")
		move_and_slide(Vector2(move_speed, 0))
		
func _physics_process(delta):
	_take_action()
		
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "attack":
		_take_action()
		set_physics_process(true)
		
# COMBAT
func _deal_damage():
	if _enemy_in_range():
		_find_closest_target().take_damage(attack_damage)
	
func take_damage(damage):
	_current_health_points -= damage
	$ColorRect.rect_size = Vector2(_current_health_points * (_initial_hp_bar_size/max_health_points), $ColorRect.rect_size.y)
	if _current_health_points <= 0:
		_die()
		
# UTILITY
func _enemy_in_range():
	return $CheckEnemies.get_overlapping_bodies().size() != 0

func _find_closest_target():
	var target
	var min_distance = 100000
	for unit in $CheckEnemies.get_overlapping_bodies():
		var distance = abs(unit.global_position.x - global_position.x)
		if distance < min_distance:
			target = unit
			min_distance = distance
	return target
	
func _check_for_ally_in_front():
	$CheckForAlliesInFront.update()
	var collider = $CheckForAlliesInFront.get_collider()
	return collider is UnitTypes.UNIT_TYPE and not collider.no_collision_with_allies

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

# DYING
func _die():
	if _dead: return
	_dead = true
	
	# drop money if unit is an enemy aka moves left
	if move_speed < 0:
		_drop_money()
	
	queue_free()
	
func _drop_money():
	var new_text = DEATH_TEXT_SCENE.instance()
	new_text.global_position = $DeathTextSpawnPoint.global_position
	var money_dropped = randi()%(max_money_on_death-min_money_on_death) + min_money_on_death
	new_text.play(money_dropped)
	get_parent().add_child(new_text)
	Global.GameManager.change_money_by(money_dropped)


