extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var power = 100

const powerUpValue = 8
const powerFallingSpeed = 70

var swimmerDirection = 1
const swimmerSpeed = 300

var drown = false
var finished = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Plywak/SwimmingAudio.play()
	$LakeAudio.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	power = clamp(power, 0, 100)
	if !finished:
		power -= powerFallingSpeed * delta
	$PowerProgressBar/PowerProgressBar.value = power
	
	if power <= 0 and !drown:
		drown = true
		$Plywak/SwimmingAudio.stop()
		$Plywak/PlywakSprite.animation = "drowning"
		$Plywak/DrowningAudio.play()
	
	if !drown:
		$Plywak.position += Vector2(swimmerDirection * swimmerSpeed * delta, 0) 
		


func _on_WholeScreenButton_pressed():
	if !finished:
		power += powerUpValue


func _on_PoolEnd_body_entered(body):
	if body.name == "Plywak":
		swimmerDirection = -1
		$Plywak.scale = Vector2(-1, 1)


func _on_PoolStart_body_entered(body):
	swimmerDirection = 0
	finished = true
	$Plywak/SwimmingAudio.stop()
	$Plywak/PlywakSprite.animation = "happy"
	$BrawoText.visible = true


func _on_BackButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
