extends KinematicBody2D

const DEATH_TEXT_SCENE = preload("res://src/scenes/battle_scene/DeathText.tscn")
const BASE = preload("res://src/objects/bases/Base.gd")

export var unit_name = ""

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
var _target: Node2D
var _target_pos: Vector2

# INITIALIZING
func _ready():
	_current_health_points = max_health_points

	
# STATE MACHINE
func _take_action():
	# if there is a unit in front we stop moving
	if _check_if_unit_in_front():
		# check if we can attack
		if _enemy_in_range():
			if $AnimatedSprite.animation != "attack": 
				set_physics_process(false)
				$AnimatedSprite.play("attack")
				_target = _find_closest_target()
				_target_pos = _target.global_position
		# else idle
		else:	
			if $AnimatedSprite.animation != "move": 
				$AnimatedSprite.play("move")
	# else move
	else:
		if $AnimatedSprite.animation != "move": 
			$AnimatedSprite.play("move")
		move_and_slide(Vector2(move_speed*Global.time_scale, 0))
		
func _physics_process(delta):
	_take_action()
	$AnimatedSprite.speed_scale = Global.time_scale
		
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "attack":
		_take_action()
		set_physics_process(true)
		
# COMBAT
func _deal_damage():
	if not is_instance_valid(_target): return
	else: _target.take_damage(attack_damage)
	
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
	
func _check_if_unit_in_front():
	$CheckForAlliesInFront.update()
	var collider = $CheckForAlliesInFront.get_collider()
	if collider == null: return false
	
	var same_side = is_enemy() == collider.is_enemy()

	if collider is UnitTypes.UNIT_TYPE:
		# return true if enemy or same side and ally with collision
		return not same_side or (not collider.no_collision_with_allies and same_side)
	else:
		# return true if enemy base
		return not same_side
		

# UNIT SIDES
func make_unit_ally():
	set_collision_layer_bit(2, true)
	set_collision_layer_bit(3, false)
	$CheckEnemies.set_collision_mask_bit(3, true)
	$CheckEnemies.set_collision_mask_bit(2, false)
	$CheckForAlliesInFront.set_collision_mask_bit(3, true)
	$CheckForAlliesInFront.set_collision_mask_bit(2, false)
	$ColorRect.color = Color.green
	move_speed = abs(move_speed)
	scale.x = abs(scale.x)

	
func make_unit_enemy():
	set_collision_layer_bit(3, true)
	set_collision_layer_bit(2, false)
	$CheckEnemies.set_collision_mask_bit(2, true)
	$CheckEnemies.set_collision_mask_bit(3, false)
	$CheckForAlliesInFront.set_collision_mask_bit(2, true)
	$CheckForAlliesInFront.set_collision_mask_bit(3, false)
	$ColorRect.color = Color.red
	move_speed = abs(move_speed) * -1
	scale.x = abs(scale.x) * -1


		
func switch_sides():
	var enemy = is_enemy()
	
	set_collision_layer_bit(2, enemy)
	set_collision_layer_bit(3, not enemy)
	$CheckEnemies.set_collision_mask_bit(3, enemy)
	$CheckEnemies.set_collision_mask_bit(2, not enemy)
	$CheckForAlliesInFront.set_collision_mask_bit(3, enemy)
	$CheckForAlliesInFront.set_collision_mask_bit(2, not enemy)
	move_speed *= -1
	scale.x *= -1
	

	$ColorRect.color = Color.green if enemy else Color.red

		

# DYING
func _die():
	if _dead: return
	_dead = true
	
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$CheckEnemies/CollisionShape2D.set_deferred("disabled", true)
	set_physics_process(false)
	
	# drop money if unit is an enemy aka moves left
	if move_speed < 0:
		_drop_money()

	$Deathsound.play()

	
	
func _drop_money():
	var new_text = DEATH_TEXT_SCENE.instance()
	new_text.global_position = $DeathTextSpawnPoint.global_position
	var money_dropped = randi()%(max_money_on_death-min_money_on_death) + min_money_on_death
	new_text.play(money_dropped)
	get_parent().add_child(new_text)
	Global.GameManager.change_money_by(money_dropped)

func is_enemy():
	return true if sign(move_speed) == -1 else false


func _on_Deathsound_finished():
	queue_free()
