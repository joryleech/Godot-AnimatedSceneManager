
# Godot-AnimatedSceneManager

**Godot-AnimatedSceneManager** is a Godot Engine plugin that enables smooth transitions between scenes using customizable animations. The plugin also supports asynchronous scene loading with built-in or custom loading screens, making it ideal for projects that require seamless scene management.

## Features

-   **Smooth Scene Transitions**: Use built-in animations or create your own transitions with Godot's animation editor.
-   **Asynchronous Scene Loading**: Load scenes in the background while displaying animated loading screens.
-   **Customizable Loading Screens**: Use the default loading screen or design your own.


## Installation

1.  Download or clone this repository into your Godot project `addons` folder:
2. Enable the plugin in your project settings (`Project -> Project Settings -> Plugins`).


## Getting Started

To use the **AnimatedSceneManager**, simply call `change_scene` or `change_scene_async` from your code to transition between scenes. The plugin handles the animation and scene loading for you.

### Example Usage

```gdscript
extends Node

func _ready():
    # Transition to "res://new_scene.tscn" with default options
    change_scene("res://new_scene.tscn")

    # Transition asynchronously with a loading screen
    change_scene_async("res://new_scene.tscn")
  
```

### Customization

You can modify the scene transition either globally or per scene transition to accomplish different effects.

**Globally**

```gdscript
var custom_options : Dictionary= {
    "speed": 2,
    "reverse_animation_on_load": true,
    "loading_scene": "res://custom_loading_screen.tscn"
}

SceneManager.set_default_options(custom_options)
```

Or 

```gdscript
SceneManager.set_default_option("speed", 2)
```

**Per Transition**
```gdscript
var custom_options = {
    "speed": 2,
    "loading_scene": "res://custom_loading_screen.tscn"
}

change_scene_async("res://next_scene.tscn", custom_options)
```

#### Options
|               Option               |                                Default Value                               |     Type    |                                               Description                                               |
|:----------------------------------:|:--------------------------------------------------------------------------:|:-----------:|:-------------------------------------------------------------------------------------------------------:|
| speed                              |                                                                          1 | float       | Speed of the transition animation.                                                                      |
| reverse_animation_on_load          |                                    FALSE                                   | bool        | If true, reverses the transition incoming animation when loading a new scene instead of using a secondary animation                                   |
| loading_scene                      | res://addons/animated_scene_manager/loading_scenes/SampleLoadingScene.tscn | String      | The scene to display while asynchronously loading the next scene.                                       |
| failed_scene_load_behavior         | FAILED_SCENE_LOAD_BEHAVIOR.log                                             | enum        | Behavior when the scene fails to load. Options: log, default, crash.                                    |
| async_use_sub_threads              |                                    TRUE                                    | bool        | If true, uses sub-threads for asynchronous scene loading.                                               |
| async_automatically_finish_loading |                                    TRUE                                    | bool        | Automatically completes scene loading when the resource is ready.                                       |
| async_file_polling_rate            |                                                                       0.01 | float       | Time interval (in seconds) to check for the scene loading progress.                                     |
| minimum_loading_screen_time        |                                                                        0.5 | float       | Minimum duration (in seconds) that the loading screen is displayed, even if the scene is loaded sooner. |
| unload_transition                  | res://addons/animated_scene_manager/transitions/Fade/FadeOut.tscn          | PackedScene | Transition animation for unloading a scene.                                                             |
| load_transition                    | res://addons/animated_scene_manager/transitions/Fade/FadeIn.tscn           | PackedScene | Transition animation for loading a scene.                                                               |
| async_loading_unload_transition    | res://addons/animated_scene_manager/transitions/Fade/FadeOut.tscn          | PackedScene | Transition animation for unloading the current scene during asynchronous loading.                       |
| async_loading_load_transition      | res://addons/animated_scene_manager/transitions/Fade/FadeIn.tscn           | PackedScene | Transition animation for loading the new scene during asynchronous loading.                             |

## Signals

The plugin emits various signals during the scene transition process from the global ``SceneManager`` object

-   **scene_loaded**: Emitted after a scene has been successfully loaded.
-   **scene_unloaded**: Emitted after a scene has been unloaded.
-   **async_scene_load_progress** (`float`): Emitted during asynchronous loading, providing load progress.
-   **async_scene_load_ready** (`String`): Emitted when an asynchronous scene is ready to be loaded.

## Custom Transitions

You can define your own transitions using Godot's animation editor or use the included ones. To change transitions, specify a custom `.tscn` file for the `load_transition` or `unload_transition`:

Transitions are scene files loaded over the current scene  of type ``Transition``. When the function ``play`` returns the animation is considered complete. This can be combined with an animation player to make timed animated changes.

Three animations are included in the files:
* FadeIn
* FadeOut
* DitherOut

## Contributing

Feel free to contribute by submitting issues or pull requests.

## License

This project is licensed under the MIT License.
