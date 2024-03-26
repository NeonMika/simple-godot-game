class_name Explosion
extends Node3D

# We can use $/root/Name to give an absolute path to a node 
# or $Name (without leading /root/) to give an relative path
# Here we select two direct children of the node this script is attached to 
@onready var smoke : GPUParticles3D = $SmokeParticle
@onready var fire : GPUParticles3D = $FireParticle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  smoke.emitting = true
  fire.emitting = true

# Smoke finishes later than fire, thus delete the whole explosion once smoke is done
func _on_smoke_particle_finished() -> void:
  queue_free()
