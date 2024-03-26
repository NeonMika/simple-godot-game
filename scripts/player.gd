class_name Player
extends AnimatableBody3D

@export_group("Speed Settings")
@export_range(1.0, 20.0, 0.25) var speed_per_second := 10.0

# $FirePoint is shorthand for get_node("FirePoint")
@onready var fire_point : Node3D = $PlayerFirePoint
const fire_pause = 1000
var last_fire = 0

@onready var world : World = $/root/World

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  # Not needed if we use @onready
  #fire_point = get_node("FirePoint")
  pass

func _physics_process(delta : float) -> void:
    # Actions must be set up in "Project > Project Settings > Input Map"
  # Nice thing: We automatically could get controller support
  if Input.is_action_just_pressed("fire"):
    if last_fire + fire_pause < Time.get_ticks_msec():
      fire()
      last_fire = Time.get_ticks_msec()
    
  var frame_speed = speed_per_second * delta
  if Input.is_action_pressed("go_left"):
    #print("go_left")
    move_and_collide(Vector3(-frame_speed, 0, 0))
    
  if Input.is_action_pressed("go_right"):
    #print("go_right")
    move_and_collide(Vector3(frame_speed, 0, 0))

# This triggers multiple times if we keep the key pressed
#func _unhandled_input(event):
#	if event is InputEventKey:
#		if event.pressed and event.keycode == KEY_ESCAPE:
#			print("Shoot")
#		elif event.pressed and event.keycode == KEY_LEFT:
#			print("Left")
#		elif event.pressed and event.keycode == KEY_RIGHT:
#			print("Right")
#		else:
#			print("Other Key: ", event)

func fire() -> void:
  # fire_point.position gives us the relative position of the fire point
  # to its parent, i.e., the player
  # .normalize() makes this vector to length 0
  world.fire_projectile_from(fire_point.global_position, fire_point.position.normalized())
  
