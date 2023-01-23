extends Control

func go_to_scene(scene_name : String):
	SceneManager.change_scene(scene_name)

func go_to_scene_async(scene_name : String):
	SceneManager.change_scene_async(scene_name)

