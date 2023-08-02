extends CharacterBody2D

const ATTACK_AREA: PackedScene = preload("res://enemy_attack_area.tscn")
const OFFSET: Vector2 = Vector2(0,30)


@onready var texture: Sprite2D = get_node("Texture")
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
		
	if player_ref == null or player_ref.can_die == true:
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
	
func spawn_attack_area():
	var attack_area = ATTACK_AREA.instantiate()
	attack_area.position = OFFSET
	add_child(attack_area)
	
func animate():
	
	if velocity.x > 0:
		texture.flip_h = false
	if velocity.x < 0:
		texture.flip_h = true
	
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
