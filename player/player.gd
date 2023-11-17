extends CharacterBody2D

signal healthChanged

@export var speed: int = 35
@onready var animations = $AnimationPlayer
@onready var effects = $Effects
@onready var hurtTimer = $HurtTimer

@export var maxHealth = 3
@onready var currentHealth: int = maxHealth

@export var knockbackPower: int = 500

func _ready():
	effects.play("RESET")


func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed
	
func UpdateAnimation():
	if(velocity.length() == 0):
		if(animations.is_playing()):
			animations.stop()
	else:
		var direction = "Down"
		if(velocity.x < 0):
			direction = "Left"
		elif (velocity.x > 0):
			direction = "Right"
		elif (velocity.y < 0):
			direction = "Up"

		animations.play("walk" + direction)		
	
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var _collider = collision.get_collider()
		
	
func _physics_process(delta):
	handleInput()
	move_and_slide()
	handleCollision()
	UpdateAnimation()


func _on_hurt_box_area_entered(area):
	if area.name == "hitBox":
		currentHealth -= 1
		if currentHealth < 0:
			currentHealth = maxHealth
		healthChanged.emit(currentHealth)
		knockback(area.get_parent().velocity)
		effects.play("hurtBlink")
		hurtTimer.start()
		await hurtTimer.timeout
		effects.play("RESET")

func knockback(enemyVelocity):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	
	print_debug(velocity)
	print_debug(position)

	move_and_slide()
	print_debug(position)
	print_debug(" ")
