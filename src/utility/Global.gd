extends Node

const GAME_MANAGER_TYPE = preload("res://src/utility/GameManager.gd")

var GameManager: GAME_MANAGER_TYPE

var first_time = false

var time_scale = 1
var sped_up_time_scale = 3
var default_time_scale = 1
