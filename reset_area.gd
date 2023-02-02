extends Area2D


func _ready():
	connect("body_entered", self, "_body_entered")

func _body_entered(body):
	if body is Player:
		body.kill()
