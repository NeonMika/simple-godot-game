class_name Enemy
extends RigidBody3D

@onready var world = $/root/World

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  # Should not really happen because the game ends before an enenmy "can fall down"
  if global_position.y < -2:
    queue_free()

func explode_and_queue_free() -> void:
  world.show_explosion_at(global_position)
  queue_free()
