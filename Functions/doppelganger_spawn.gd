extends Node3D

@onready var ST = $"../../../Timers/SpawnTimer"
@onready var CT = $"../../../Timers/CooldownTimer"
@onready var ChaseMusic = $"../../../Audio/ChaseMusic"

@onready var Cooper =  get_tree().get_nodes_in_group("Cooper")
@onready var D_POSarray: Array = get_tree().get_nodes_in_group("Spawn")

func _ready():
	pass


func _cooper_enter(Cooper):
	#Connected to body entered 
	print("Potential Danger")
	DS_spawn_timer_start()

func _cooper_exit(Cooper):
	#Connected to body exited 
	print("Crisis Avoided.")
	ST.stop()


#Timers -------------------------------------------------------------------

func DS_spawn_timer_start():
	print("Doppelganger spawn timer started!")
	ST.start(randi_range(5, 30))


func DS_on_spawn_timer_timeout():
	print("Doppelganger Spawn Timer timed out! Doppelganger spawned!")
	_doppelganger_inst()
	CT.start(randi_range(60, 90))
	ST.stop()


func _on_cooldown_timer_timeout():
	print("Cooldown timer ended, DS spawn timer started!")
	DS_spawn_timer_start()



#Adding  -------------------------------------------------------------------

func _doppelganger_inst():
	var doppelgangerScene = preload("res://InstanceScenes/Doppelganger/doppelganger.tscn")
	var doppelgangerInst = doppelgangerScene.instantiate()
	var doppelgangerPos = D_POSarray.pick_random()
	print("Doppelganger spawned!")
	doppelgangerPos.add_child(doppelgangerInst)
	#Run World Enviroment animation here too! 
	#And music wherever that ends up positionally...
	ChaseMusic.play()
