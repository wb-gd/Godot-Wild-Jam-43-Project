extends Sprite

export var speed := 1.5

func _process(delta):
	rotation += speed * delta
