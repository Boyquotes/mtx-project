extends Node

func stop_main_music():
	$MainMusic.stop()
	
func start_main_music():
	if not $MainMusic.playing: $MainMusic.play()
