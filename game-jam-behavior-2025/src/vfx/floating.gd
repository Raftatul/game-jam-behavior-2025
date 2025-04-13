extends Node3D

@export var floatduration: Vector2 = Vector2(1,2)
@export var floatintensity: float

var floaters:Array

func _ready() -> void:
	floaters = get_children()
	
	for floater in floaters:
		await randf()
		animate(floater)


func animate(node: Node3D):
	
	var tweener:Tween = create_tween()
	
	tweener.set_loops(0)
	
	tweener.set_ease(Tween.EASE_IN_OUT)
	tweener.set_trans(Tween.TRANS_QUAD)
	
	tweener.tween_property(node,"position:y",node.position.y + floatintensity, randf_range(floatduration.x,floatduration.y))
	tweener.tween_property(node,"position:y",node.position.y - floatintensity, randf_range(floatduration.x,floatduration.y))
	
	tweener.play()
