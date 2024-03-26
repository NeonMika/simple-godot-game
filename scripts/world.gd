class_name World
extends Node3D

# Using @export, @export_range, etc. we can change settings in the editor
# @export_group allows us to make things more beautiful
@export_group("Player Settings")
# Instead of using a fixed reference using $... or %..., we can also make
# settings in the editor. PackedScene says that we want a predefined scene,
# which would be called "Prefab" in Unity for example.
@export var projectile_scene : PackedScene 

@export_group("Enemy Settings")
@export_range(0.25, 5.0, 0.005) var enemy_creation_speed = 1.0
@export_range(0.001, 0.1, 0.001) var enemy_creation_speed_change = 0.005

var enemy_scene := preload("res://scenes/enemy.tscn")
var explosion_scene = preload("res://scenes/explosion.tscn")

@onready var enemy_creation_timer := %EnemyCreationTimer as Timer

@onready var player := $Player as Player
@onready var game_over_label := $Player/PlayerLabel as Label3D

@onready var projectile_node := %Projectiles


@onready var enemy_creation_speed_value_label := %EnemyCreationSpeedValueLabel as Label3D

var enemies_defended = 0
@onready var enemies_defended_value_label := %EnemiesDefendedValueLabel as Label3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  show_start_animation()
  
func show_start_animation() -> void:
  for x in range(-15, 15, 3):
    show_explosion_at(Vector3(x, 2, 15))
    await get_tree().create_timer(0.15).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
  pass
  
func _on_enemy_creation_timer_timeout() -> void:
  var new_enemy : RigidBody3D = enemy_scene.instantiate() as RigidBody3D
  $Enemies.add_child(new_enemy, true)
  new_enemy.global_position = Vector3(randf_range(-11, 11), 5, -25)
  new_enemy.apply_impulse(Vector3.BACK * 10)
  enemy_creation_speed = max(enemy_creation_speed - enemy_creation_speed_change, 0.250)
  enemy_creation_timer.wait_time = enemy_creation_speed
  enemy_creation_speed_value_label.text = str(enemy_creation_timer.wait_time) + "s"


func _on_tree_printing_timer_timeout() -> void:
  print_tree_pretty()

func fire_projectile_from(from : Vector3, dir : Vector3) -> void:
  if(projectile_scene != null):
    var new_projectile = projectile_scene.instantiate() as RigidBody3D
    projectile_node.add_child(new_projectile, true)
    new_projectile.global_position = from
    new_projectile.apply_impulse(dir.normalized() * 20)
    pass
  else:
    print("no projectile resource set")

# called from projectile
func defend_enemy(enemy : Enemy) -> void:
  enemy.explode_and_queue_free()

  enemies_defended += 1
  enemies_defended_value_label.text = str(enemies_defended)

func show_explosion_at(p : Vector3) -> void:
  var e : Explosion = explosion_scene.instantiate()
  
  var explosion_parent : Node3D = %Explosions
  explosion_parent.add_child(e, true)
  e.global_position = p



func _on_target_line_area_body_entered(body: Node3D) -> void:
  # following check is not needed because target line uses mask 2 (i.e., it only
  # detects collisions with enemies)
  # if "Enemy" in body.name:
  game_over()
    
func game_over() -> void:
  print("ENEMY REACHED TARGET LINE!")
  if enemies_defended == 1:
    game_over_label.text = "GAME OVER after 1 defended enemy"
  else:
    game_over_label.text = "GAME OVER after %d defended enemies" % enemies_defended
  get_tree().paused = true
