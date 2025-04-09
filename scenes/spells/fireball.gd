extends Node3D

const SPEED=10
var dir=Vector3(1,0,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position+=global_transform.basis*Vector3(0,0,-SPEED)*delta


func _on_despwantime_timeout() -> void:
	self.queue_free()
