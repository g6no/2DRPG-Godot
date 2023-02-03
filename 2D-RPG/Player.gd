extends KinematicBody2D

# Stats
export var cur_hp : int = 10
export var max_hp : int = 10
export var move_speed : int = 250
export var damage : int = 1 

# XP and gold
var gold : int = 0
var cur_lvl : int = 0
var cur_xp : int = 0
var xp_to_next_level : int = 50
var xp_to_level_increase_rate : float = 1.2

# Raycast and movement
export var interact_dist : int = 70
var velocity = Vector2()
var face_dir = Vector2()

# Onready Variables
onready var ray_cast = $RayCast2D
onready var anim = $AnimatedSprite
onready var ui = get_node("/root/Main/CanvasLayer/UI")

func _ready():
	ui.update_level_text(cur_lvl)
	ui.update_health_bar(cur_hp, max_hp)
	ui.update_xp_bar(cur_xp, xp_to_next_level)
	ui.update_gold_text(gold)

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		try_interact()

func _physics_process(delta):
	handle_movement()
	handle_animations()
	
func handle_movement():
	velocity = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		face_dir = Vector2(1,0)
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		face_dir = Vector2(-1,0)
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		face_dir = Vector2(0,-1)
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		face_dir = Vector2(0,1)
	
	velocity = velocity.normalized()
	move_and_slide(velocity*move_speed, Vector2.ZERO)

func handle_animations():
	if velocity.x > 0:
		play_animation("move_right")
	elif velocity.x < 0:
		play_animation("move_left")
	elif velocity.y < 0:
		play_animation("move_up")
	elif velocity.y > 0:
		play_animation("move_down")
	elif face_dir.x == 1:
		play_animation("idle_right")
	elif face_dir.x == -1:
		play_animation("idle_left")
	elif face_dir.y == 1:
		play_animation("idle_down")
	elif face_dir.y == -1:
		play_animation("idle_up")
		
func play_animation(animation):
	if anim.animation != animation:
		anim.play(animation)
		
func take_damage(damage):
	print("Damaged: ", damage)
	cur_hp -= damage
	ui.update_health_bar(cur_hp, max_hp)
	if cur_hp <= 0:
		die()

func die():
	get_tree().reload_current_scene()
	
func give_xp(xp_given):
	cur_xp += xp_given
	if cur_xp >= xp_to_next_level:
		level_up()
	ui.update_xp_bar(cur_xp, xp_to_next_level)

func level_up():
	var overflow_xp = cur_xp - xp_to_next_level
	xp_to_next_level *= xp_to_level_increase_rate
	cur_xp = overflow_xp
	cur_lvl += 1
	ui.update_level_text(cur_lvl)

func give_gold(gold_given):
	gold += gold_given
	ui.update_gold_text(gold)
	
func try_interact():
	ray_cast.cast_to = face_dir * interact_dist
	if ray_cast.is_colliding():
		if ray_cast.get_collider() is KinematicBody2D:
			ray_cast.get_collider().take_damage(damage)
		elif ray_cast.get_collider().has_method("on_interact"):
			 ray_cast.get_collider().on_interact(self)
