extends Area2D

export var gold_to_give = 5

func on_interact(player):
	player.give_gold(gold_to_give)
	queue_free()
