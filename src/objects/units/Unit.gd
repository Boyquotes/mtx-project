extends KinematicBody2D

const DEATH_TEXT_SCENE = preload("res://src/scenes/battle_scene/DeathText.tscn")
const BASE = preload("res://src/objects/bases/Base.gd")

enum DIR {SIDE,UP,DOWN}

export var unit_name = ""

export var move_speed = 100
export var attack_damage = 1
export var max_health_points = 10;
export var cost = 100;

export var min_money_on_death = 10;
export var max_money_on_death = 100;

export var corner_turn_time = 0.8;

export var no_collision_with_allies = false

onready var _initial_hp_bar_size = $ColorRect.rect_size.x

var _current_health_points 
var _dead = false
var _target: Node2D
var _target_pos: Vector2
var _current_dir = DIR.SIDE
var _moving_sideways = true
var _switch_disabled = false
var _switch_disabled_timer = 0

# INITIALIZING
func _ready():
	randomize()
	_current_health_points = max_health_points
	
func _physics_process(delta):
	_switch_disabled_timer += delta * Global.time_scale 
	if _switch_disabled and _switch_disabled_timer > corner_turn_time: 
		_switch_disabled = false
	
	if _enemy_in_range():
		_attack()
	elif _check_if_unit_in_front():
		return
	else:
		_movement()
	$AnimatedSprite.speed_scale = Global.time_scale
		

# ACTIONS
func _attack():
	if $AnimatedSprite.animation != "attack": 
			set_physics_process(false)
			$AnimatedSprite.play("attack")
			_target = _find_closest_target()
			_target_pos = _target.global_position
		# else idle
	else:	
		if $AnimatedSprite.animation != "move": 
			$AnimatedSprite.play("move")

func _can_move_in_dir(direction):
	match(direction):
		DIR.SIDE:
			return not $WallSide.is_colliding() and not $WallSide2.is_colliding()
		DIR.UP:
			return not $WallUp.is_colliding()
		DIR.DOWN:
			return not $WallDown.is_colliding()
		_:
			return false

func _disable_switch():
	_switch_disabled_timer = 0
	_switch_disabled = true
	
func _move():
	var movement = Vector2.ZERO
	match(_current_dir):
		DIR.UP:
			movement += Vector2(0, -abs(move_speed))
		DIR.DOWN:
			movement += Vector2(0, abs(move_speed))
	if _moving_sideways:
		movement += Vector2(move_speed, 0)
	print(movement)
	move_and_slide(movement*Global.time_scale)	
	
func _movement():
	if $AnimatedSprite.animation != "move": 
		$AnimatedSprite.play("move")
	
	var checks = [_can_move_in_dir(DIR.SIDE),_can_move_in_dir(DIR.UP),_can_move_in_dir(DIR.DOWN)]
	var dir_checks = [_current_dir == DIR.SIDE, _current_dir == DIR.UP, _current_dir == DIR.DOWN]
	if _switch_disabled:
		_move()
		return
		
	if _current_dir != DIR.SIDE and checks[0]:
		if not _can_move_in_dir(_current_dir):
			_current_dir = DIR.SIDE
		_moving_sideways = true
		_disable_switch()
	else:
		# else choose a random option
		var options = []
		if checks[0]: options.append(DIR.SIDE)
		if checks[1] and _current_dir != DIR.DOWN: options.append(DIR.UP)
		if checks[2] and _current_dir != DIR.UP: options.append(DIR.DOWN)
		
		print(options)
		if options.size() == 0:
			if dir_checks[1]:
				_disable_switch()
				_current_dir = DIR.DOWN
			elif dir_checks[2]:
				_disable_switch()
				_current_dir = DIR.UP
			elif dir_checks[0]:
				pass
		else:
			var dir = options[randi()%options.size()]
			if _current_dir != dir: 
				_disable_switch()
				_current_dir = options[randi()%options.size()]
				if _current_dir != DIR.SIDE:
					_moving_sideways = false	
	_move()
	

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "attack":
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
	$WallDown.set_collision_mask_bit(4, true)
	$WallUp.set_collision_mask_bit(4, true)
	$WallSide.set_collision_mask_bit(4, true)
	$WallDown.set_collision_mask_bit(5, false)
	$WallUp.set_collision_mask_bit(5, false)
	$WallSide.set_collision_mask_bit(5, false)
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
	$WallDown.set_collision_mask_bit(4, false)
	$WallUp.set_collision_mask_bit(4, false)
	$WallSide.set_collision_mask_bit(4, false)
	$WallDown.set_collision_mask_bit(5, true)
	$WallUp.set_collision_mask_bit(5, true)
	$WallSide.set_collision_mask_bit(5, true)
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
