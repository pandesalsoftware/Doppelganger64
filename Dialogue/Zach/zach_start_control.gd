extends Control

signal d_FIN

@onready var icon = $Icon
@onready var lbl = $TextureRect/Speech


var messages = [
	"My name is Zach.", 
	"I'm looking for York!",
	"He's my...other half.",
	"Can I come with you?"
]

var curr_msg = 0
var typing_speed = 0.05

var full_text  = ""
var is_typing = false

func _ready():
	icon.visible = false
	_start_dialogue()

func _start_dialogue():
	visible = true 
	curr_msg = 0 
	_show_msg()

#MSG 6
func _show_msg():
	#Color Change logic if wanted, uncomment.
	#________________
	#if curr_msg >= 6:
		#lbl.add_theme_color_override("font_color", Color("bac6c1"))
	#else:
		#lbl.add_theme_color_override("font_color", Color("bfa303"))
		#________________
		
	icon.visible = false 
	full_text = messages[curr_msg]
	lbl.text = ""
	is_typing = true
	
	for c in full_text:
		if not is_typing:
			lbl.text = full_text
			return
	
		lbl.text += c 
		await  get_tree().create_timer(typing_speed).timeout
		
	is_typing = false 
	icon.visible = true 

func _input(event):
	if not visible: 
		return 
		
	if event.is_action_pressed("Proceed"):
		if is_typing:
			is_typing = false 
			lbl.text = full_text
			icon.visible = true 
		
		else: 
			curr_msg += 1 
			
			if curr_msg == 6: 
				$Cassette_AP.play()
			
			if curr_msg < messages.size():
				_show_msg()
			else: 
				_end_dialogue()

func _end_dialogue():
	visible = false 
	emit_signal("d_FIN")


func _on_skip_btn_pressed() -> void:
	#Skip 'Cutscene' here , need to add button first, will come back later 
	pass
