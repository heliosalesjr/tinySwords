extends CharacterBody2D

@onready var attack_area_collision: CollisionShape2D = get_node("AttackArea/Collision")

@onready var animation: AnimationPlayer = get_node("Animation")

@export var move_speed: float = 256.0

@onready var texture = $Texture



var can_attack: bool = true

func _physics_process(_delta: float) -> void:
	
	if can_attack == false:
		return
	
	move()
	animate()
	attack_handler()
	
func move() -> void:
	var direction: Vector2 = get_direction()
	velocity = direction * move_speed
	move_and_slide()

func get_direction() -> Vector2:
	return Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	
func animate() -> void:
	
	if velocity.x > 0:
		texture.flip_h = false
		attack_area_collision.position.x = 59
		
	if velocity.x < 0:
		texture.flip_h = true
		attack_area_collision.position.x = -59
		
	if velocity != Vector2.ZERO:
		animation.play("run")
		return
		
	animation.play("idle")

func attack_handler() -> void:
	if Input.is_action_just_pressed("attack") and can_attack:
		can_attack = false
		
		animation.play("attack")

func _on_animation_finished(_anim_name):
	can_attack = true
