extends KinematicBody2D

# Stats
var cur_hp : int = 5
export var max_hp : int = 5
export var move_speed : int = 150
export var xp_to_give : int = 30
export var damage : int = 1

# Attack Variables
export var attack_rate : float = 0.5
export var attack_dist : int = 80
export var chase_dist : int = 400

# Onready Variables
onready var timer = $AttackTimer
onready var player = get_node("/root/Main/Player")

func _ready():
	timer.wait_time = attack_rate
	timer.start()

func _physics_process(delta):
	var dist = position.distance_to(player.position)
	
	if dist > attack_dist and dist < chase_dist:
		var velocity = (player.position - position).normalized()
		move_and_slide(velocity * move_speed)


func _on_AttackTimer_timeout():
	if position.distance_to(player.position) <= attack_dist:
		player.take_damage(damage)

func take_damage(damage):
	cur_hp -= damage
	if cur_hp <= 0:
		die()
		
func die():
	player.give_xp(xp_to_give)
	queue_free()
