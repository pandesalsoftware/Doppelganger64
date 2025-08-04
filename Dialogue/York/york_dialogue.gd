extends Control

var STARTdialogue = preload("res://Dialogue/York/yorkcontrol.tscn")


func _yorkSTARTdialogue():
	var Sd = STARTdialogue.instantiate()
	add_child(Sd)
