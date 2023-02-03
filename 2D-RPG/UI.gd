extends Control


onready var level_text = get_node("BG/LVLBG/LVLTxt")
onready var health_bar = get_node("BG/HealthBar")
onready var xp_bar = get_node("BG/XPBar")
onready var gold_text = get_node("BG/GoldLabel")


func update_level_text(level):
	level_text.text = str(level)

func update_health_bar(cur_hp, max_hp):
	health_bar.value = (100/max_hp) * cur_hp
	
func update_xp_bar(cur_xp, xp_to_next_level):
	xp_bar.value = (100/ xp_to_next_level) * cur_xp
	
func update_gold_text(gold):
	gold_text.text = "Gold: " + str(gold)
