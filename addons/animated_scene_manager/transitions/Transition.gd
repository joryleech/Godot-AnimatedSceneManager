extends CanvasLayer
class_name Transition

signal animation_complete
@onready var animation_player : AnimationPlayer = $AnimationPlayer

func play(opts={}):
	animation_player.stop(true)
	var animation_speed : float = opts['speed']
	var animation_reverse : bool = opts['reverse']
	if(animation_reverse):
		animation_speed *= -1
		
	animation_player.play("transition",-1,animation_speed, animation_reverse)
	await animation_player.animation_finished
	return
	
