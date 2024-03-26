class_name Projectile
extends RigidBody3D

@onready var world : World = $/root/World

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
  if global_position.y < -2:
    queue_free()

func _on_detection_area_body_entered(body) -> void:
  print("> body within detection area of ", self, ":", body.name)
  
  # following check is not needed because projectile detection area uses 
  # mask 2 (i.e., it only detects collisions with enemies)
  
  # if "Enemy" in body.name:
  var enemy = body as RigidBody3D
  world.defend_enemy(enemy)
  
  print(">>> body was enemy, destroyed")
  # else:
  #   print(">>> body is no enemy, let it live")
