extends Control

# Current value
@export var level : float = 1

@export
var col_full : Color = Color(0.173, 0.714, 0.294)
@export
var col_high : Color = Color(0.361, 0.686, 0.408)
@export
var col_med : Color = Color(0.641, 0.613, 0.32)
@export
var col_low : Color = Color(1, 0.228, 0.188)

var indicator_panel : Panel # Fetched at runtime
var indicator_stylebox : StyleBoxFlat
var indicator_container : MarginContainer
var container_size : float
var container_margin_top : float

func _ready():
	indicator_panel = $BG_panel/Margin/Indicator
	indicator_container = $BG_panel/Margin
	indicator_stylebox = indicator_panel.get_theme_stylebox("panel")
	container_size = indicator_container.get_size().y - (
		indicator_container.get_theme_constant("margin_top") + 
		indicator_container.get_theme_constant("margin_bottom")
	)
	container_margin_top = indicator_container.get_theme_constant("margin_top")

func _process(delta):
	level = clampf(level, 0, 1)
	
	if (level > 0.9):
		indicator_stylebox.bg_color = col_full
	elif level > 0.6:
		indicator_stylebox.bg_color = col_high
	elif level > 0.3:
		indicator_stylebox.bg_color = col_med
	else:
		indicator_stylebox.bg_color = col_low
	
	# Map current level to margin container top offset
	var current_margin_top = (1 - level) * container_size + container_margin_top
	indicator_container.add_theme_constant_override("margin_top", int(current_margin_top))
	
