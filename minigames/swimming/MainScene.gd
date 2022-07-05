extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var power = 100

const powerUpValue = 8
const powerFallingSpeed = 30

var swimmerDirection = 1
const swimmerSpeed = 200

var drown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	power = clamp(power, 0, 100)
	power -= powerFallingSpeed * delta
	$PowerProgressBar/PowerProgressBar.value = power
	
	if power <= 0:
		drown = true
	
	if !drown:
		$Plywak.position += Vector2(swimmerDirection * swimmerSpeed * delta, 0) 
		


func _on_WholeScreenButton_pressed():
	power += powerUpValue
	pass # Replace with function body.



func _on_PoolEnd_body_entered(body):
	if body.name == "Plywak":
		swimmerDirection = -1
		$Plywak.scale = Vector2(-1, 1)


func _on_PoolStart_body_entered(body):
	swimmerDirection = 0
