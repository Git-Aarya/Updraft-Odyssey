extends ColorRect

# Size and corner radius of the rounded rectangle
var rect_size: Vector2 = Vector2(200, 100)
var corner_radius: float = 20.0

# Color of the rectangle
var rect_color: Color = Color(1, 0, 0)

func _ready():
	# Set the size of the ColorRect
	self.rect_min_size = rect_size
	queue_redraw()  # Schedule the _draw() method to be called

func _draw():
	# Draw the rounded rectangle
	draw_rounded_rect(Vector2.ZERO, rect_size, corner_radius, rect_color)

# Function to draw a rounded rectangle
func draw_rounded_rect(position: Vector2, size: Vector2, radius: float, color: Color) -> void:
	var rect = Rect2(position, size)
	var arc_points = 16  # Number of points in each corner arc

	# Generate corner arcs
	var top_left = generate_arc(rect.position + Vector2(radius, radius), PI, 1.5 * PI, radius, arc_points)
	var top_right = generate_arc(rect.position + Vector2(rect.size.x - radius, radius), 1.5 * PI, 2 * PI, radius, arc_points)
	var bottom_right = generate_arc(rect.position + Vector2(rect.size.x - radius, rect.size.y - radius), 0, 0.5 * PI, radius, arc_points)
	var bottom_left = generate_arc(rect.position + Vector2(radius, rect.size.y - radius), 0.5 * PI, PI, radius, arc_points)

	# Combine all points
	var points = top_left
	points.append_array(top_right)
	points.append_array(bottom_right)
	points.append_array(bottom_left)

	# Draw the filled rounded rectangle
	draw_polygon(points, [color])

# Helper function to generate arc points
func generate_arc(center: Vector2, start_angle: float, end_angle: float, radius: float, arc_points: int) -> PoolVector2Array:
	var points = PoolVector2Array()
	for i in range(arc_points + 1):
		var angle = start_angle + i * (end_angle - start_angle) / arc_points
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	return points


