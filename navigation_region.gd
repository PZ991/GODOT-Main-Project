extends Node2D
@onready var navigation_region_2d = $NavigationRegion2D

var polygon_points = [
	Vector2(0, 0),
	Vector2(100, 0),
	Vector2(100, 100),
	Vector2(0, 100)
]

func _ready():
	var polygon = NavigationPolygon.new()
	var vertices = PackedVector2Array([Vector2(-10, -10), Vector2(0, 200), Vector2(200, 200), Vector2(200, 0)])
	#polygon.vertices = vertices
	#var indices = PackedInt32Array([0, 1, 2, 3])
	#polygon.add_polygon(indices)
	var vertices2 = PackedVector2Array([Vector2(100, 100), Vector2(100, 150), Vector2(150, 150), Vector2(150, 0)])
	polygon.add_outline(vertices)
	polygon.add_outline(vertices2)
	polygon.make_polygons_from_outlines()
	navigation_region_2d.navigation_polygon=polygon
