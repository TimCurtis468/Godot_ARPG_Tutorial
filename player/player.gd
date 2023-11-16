extends CharacterBody2D

@export var speed: int = 35
@onready var animations = $AnimationPlayer
@onready var hurtColor = $Sprite2D/ColorRect

@export var maxHealth = 3
@onready var currentHealth: int = maxHealth

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
		var collider = collision.get_collider()
		
	
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
		print_debug(currentHealth)
