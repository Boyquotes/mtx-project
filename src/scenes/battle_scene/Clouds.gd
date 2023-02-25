extends ParallaxBackground

export var avg_scroll_speed = 50

func _ready():
	avg_scroll_speed += (randi()%50) - 25
	avg_scroll_speed *= -1 if randi()%2 == 0 else 1

func _process(delta):
	scroll_offset.x += avg_scroll_speed * delta
