extends Node
signal scene_loaded
signal async_scene_load_progress(float)
signal async_scene_load_ready(String)
signal scene_unloaded

enum FAILED_SCENE_LOAD_BEHAVIOR {
	log,
	default,
	crash
}

enum TRANSITION_TYPE {
	load,
	unload,
}

var DEFAULT_SCENE_CHANGE_OPTIONS={
	"speed": 1,
	"invert_on_load": true,
	"loading_scene": "res://addons/animated_scene_manager/loading_scenes/SampleLoadingScene.tscn",
	"failed_scene_load_behavior": FAILED_SCENE_LOAD_BEHAVIOR.log,
	"async_use_sub_threads": true,
	"async_automatically_finish_loading": true,
	"async_file_polling_rate": 0.01,
	"minimum_loading_screen_time": 0.5,
	"unload_transition": "res://addons/animated_scene_manager/transitions/FadeTransition.tscn",
	"load_transition": "res://addons/animated_scene_manager/transitions/FadeTransition.tscn",
	
}

func change_scene(scene_name, opts = {}):
	#Unload animation
	
	#Load Scene
	get_tree().change_scene_to_file(scene_name)
	emit_signal("scene_unloaded")
	emit_signal('scene_loaded')
	#Load animation
	
func change_scene_async(scene_name, opts = {}):
	#TODO Unload Animation
	await play_transition(TRANSITION_TYPE.unload, opts, false)
	#Unload main scene, load loading screen
	var loading_scene_url = _get_option_value(opts, "loading_scene")
	get_tree().change_scene_to_file(loading_scene_url)
	emit_signal("scene_unloaded")
	
	var async_use_sub_threads = _get_option_value(opts, "async_use_sub_threads")
	var scene_loader_error : int = ResourceLoader.load_threaded_request(scene_name,"",async_use_sub_threads)
	if(scene_loader_error != OK):
		return handle_unfound_scene(scene_loader_error,opts)
	await _check_asymc_resource_loading_state(scene_name, opts)
	
	var automatically_finish_loading = _get_option_value(opts, "async_automatically_finish_loading")
	if(automatically_finish_loading):
		finish_loading_scene(scene_name,opts)
	emit_signal('scene_loaded')
	
func play_transition(transition_type : TRANSITION_TYPE, opts={}, is_loading_screen=false):
	return
	
func finish_loading_scene(scene_name, opts={}):
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene_name))
	
func _check_asymc_resource_loading_state(resource_name : String, opts={}):
	var polling_time = _get_option_value(opts, 'async_file_polling_rate')
	var minimum_loading_screen_time = _get_option_value(opts, 'minimum_loading_screen_time')
	while(true):
		var loading_progress : Array = []
		var loading_status : ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(resource_name, loading_progress)
		if(loading_status == ResourceLoader.THREAD_LOAD_LOADED):
			emit_signal('async_scene_load_progress', 0.99)
			emit_signal('async_scene_load_ready', resource_name)
			await get_tree().create_timer(minimum_loading_screen_time).timeout
			return
		elif(loading_status == ResourceLoader.THREAD_LOAD_IN_PROGRESS):
			emit_signal('async_scene_load_progress', loading_progress[0])
		else:
			print("Loading error")
			#TODO handle
			return
		await(get_tree().create_timer(polling_time).timeout)
	
	
func handle_unfound_scene(error, opts={}):
	var error_handle_behavior = _get_option_value(opts, 'failed_scene_load_behavior')
	match error_handle_behavior:
		FAILED_SCENE_LOAD_BEHAVIOR.log:
			print("[SceneManager] Unable to load scene. Error: "+error)
		FAILED_SCENE_LOAD_BEHAVIOR.default:
			#TODO
			pass
		FAILED_SCENE_LOAD_BEHAVIOR.crash:
			assert(error == OK)
	
func _get_option_value(options : Dictionary, key : String):
	if(options.has(key)):
		return options[key]
	elif(DEFAULT_SCENE_CHANGE_OPTIONS.has(key)):
		return DEFAULT_SCENE_CHANGE_OPTIONS[key]
	return null
	
func set_default_options(new_options : Dictionary):
	for key in new_options.keys():
		set_default_option(key, new_options[key])

## Sets the value of a single default option.
##Requires both the key and value to be non null
func set_default_option(key : String, value):
	assert(key != null)
	assert(value != null)
	if(key != null && value != null):
		DEFAULT_SCENE_CHANGE_OPTIONS[key]=value
		
