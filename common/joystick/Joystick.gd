extends CanvasLayer

signal move_vector

##### JAK UŻYWAĆ #####
# Dodaj sb canvas layer do sceny
# kliknij na inspector -> node
# on będzie miał signal "use_move_vector"
# dodaj sobie to do jakiegoś skryptu
# jest to funkcja która daje Vector2 z przesunięciem joya - od -1 do 1
# przyklady:
#   -1 -1 => lewy górny
#   -1  0 => lewy środek
#   0.5 0.5 => lekko w prawy dół

export var changePosOnTap = true
export var fadeOut = true
export var fadeOutTimeMs = 500

var _fadeOutTimer = 2000
const _legalAreaBorder = Vector2(530, 220)

# YOU HAVE TO UPDATE THIS IF YOU CHANGE SIZE/SCALE OF BUTTON!!!
const buttonSize = Vector2(256, 256)
var initInnerCirclePos: Vector2
var _pressed = false

func _map(x: float, in_min: float, in_max: float, out_min: float, out_max: float) -> float:
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;

func _mapVector2(vect: Vector2, in_min: float, in_max: float, out_min: float, out_max: float):
	return Vector2(_map(vect.x, in_min, in_max, out_min, out_max), _map(vect.y, in_min, in_max, out_min, out_max))


func _ready():
	initInnerCirclePos = $InnerCircle.position

func _process(delta):
	if _pressed:
		_fadeOutTimer = 2000
	elif fadeOut:
		_fadeOutTimer = clamp(_fadeOutTimer - (delta*1000), 0, fadeOutTimeMs)
	var mod1 = $TouchScreenButton.modulate
	mod1.a = _map(_fadeOutTimer, 0, fadeOutTimeMs, 0, 1)
	$TouchScreenButton.modulate = mod1
	var mod2 = $InnerCircle.modulate
	mod2.a = _map(_fadeOutTimer, 0, fadeOutTimeMs, 0, 1)
	$InnerCircle.modulate = mod2

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed() and (event.position.x < _legalAreaBorder.x and event.position.y > _legalAreaBorder.y):
			if changePosOnTap:
				$TouchScreenButton.position = event.position - (buttonSize / 2)
				$InnerCircle.position = event.position
				initInnerCirclePos = $InnerCircle.position
			_pressed = true
		else:
			$InnerCircle.position = initInnerCirclePos
			emit_signal("move_vector", Vector2(0, 0))
			_pressed = false
	if event is InputEventScreenDrag and _pressed:
		var move_vector = calculate_move_vector(event.position)
		$InnerCircle.position = initInnerCirclePos + move_vector
		var _half = buttonSize.x / 2
		move_vector = _mapVector2(move_vector, -_half, _half, -1, 1)
		emit_signal("move_vector", move_vector)
		

func calculate_move_vector(event_position: Vector2):
	var texture_center = $TouchScreenButton.position + (buttonSize / 2)
	return (event_position - texture_center).clamped(buttonSize.x / 2)
