extends Node2D

export var text: String = ""
export var highlight: bool = false
export var highlight_color = Color("65d139")
export(Texture) var number_texture
export var default_color = Color("343434")
export var number: int = 1

func _ready():
	$AnimatedSprite.set_frame(8*number)
	
func _process(delta):
	if text == "":
		$Text.hide()
	else:
		$Text.show()
	$Text.set_text(text)
	$Background.set_frame_color(_get_color())
	$Sprite.set_texture(number_texture)
	

func set_highlight(value: bool):
	highlight = value
	if highlight:
		get_node("../DMXControl").set_color(number, _get_color())
	else:
		get_node("../DMXControl").set_color(number, Color.black)

func _get_color() -> Color:
	if highlight:
		return highlight_color
	else:
		return default_color

