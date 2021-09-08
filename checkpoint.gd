extends CanvasLayer
#base node. usually canvaslayer so it stays on top

var base:Node #usual base node
var text:Node #the text that we use to show the checkpoint
onready var pos = $pos #node2d to postion the text

#make an array of keys that can be registered to skip to checkpoints
var keys = [KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9]


func _ready():
	base = get_node("/root/base") #load the base, always do this :)
	text = load("res://level stuff/text.tscn").instance() #make the text
	pos.add_child(text) #put the text into the screen
	pos.position = Vector2(5, 20) #position the text so it has a bit of padding
	text.bbcode_text = str(0) #set it to zero


func _process(delta):
	#every frame we update the checkpoint. ideally this would only get called when the respawn actually updates, but we'll have to do this until i update the code to emit a signal on respawn.
	text.bbcode_text = str(base.respawn)
	
func _input(event):
	#collect event. if it's a keyboard input and in the list that we mentioned earlier, and also not held down
	if event is InputEventKey and event.scancode in keys and not event.echo:
		var cp = keys.find(event.scancode, 0) + 1 #get the checkpoint 'id'

		base.propagate_call("check_respawn", [cp]) #call for respawns in base to happen. if the checkpoint number is too high, it wouldn't match any. and then you wouldn't respawn.
		base.emit_signal("respawn_done") #finish off
