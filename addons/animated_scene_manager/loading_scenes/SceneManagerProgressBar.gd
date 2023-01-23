extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	SceneManager.async_scene_load_progress.connect(_on_update_progress)

func _on_update_progress(progress : float):
	print(progress)
	set_value(progress*100)
