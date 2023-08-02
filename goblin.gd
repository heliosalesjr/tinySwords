extends CharacterBody2D

@onready var animation: AnimationPlayer = get_node("Animation")
@onready var aux_animation_player: AnimationPlayer = get_node("AuxAnimationPlayer")
var player_ref: CharacterBody2D = null
var can_die: bool = false

@export var health = 3

@export var move_speed: float = 148.0

@export var distance_threshold: float = 60.0

func _physics_process(_delta):
	if can_die:
		return
		
	if player_ref == null:
		velocity = Vector2.ZERO
		animate()
		return
	var direction: Vector2 = global_position.direction_to(player_ref.global_position)
	var distance: float = global_position.distance_to(player_ref.global_position)
	
	if distance < distance_threshold:
		animation.play("attack")
		return
		
	velocity = direction * move_speed
	move_and_slide()
	animate()

func animate():
	if velocity != Vector2.ZERO:
		animation.play("run")
		return
	animation.play("idle")

func update_health(value):
	health -= value
	if health <= 0:
		can_die = true
		animation.play("death")

		
		return
		
	aux_animation_player.play("hit")
	
func _on_detection_area_body_entered(body):
	player_ref = body


func _on_detection_area_body_exited(_body):
	player_ref = null


func _on_animation_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()
