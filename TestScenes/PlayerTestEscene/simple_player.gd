extends Sprite2D

@export var level_path: NodePath
@export var speed: float = 400.0
@export var spawn_raius: float = 0.0

var level: BaseVirtualScene2D = null
var is_flip_h: bool = false

var quantity_to_spawn = 0
var player_collider: PlayerCollider

func _ready():
	self.level = get_node(self.level_path) as BaseVirtualScene2D
	self.player_collider = PlayerCollider.new(self.level, self)
	self.level.add_virtual_child(self.player_collider)
	$Weapon.set_level(self.level)
	randomize()

func _process(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	position += input_direction * speed * delta
	
	if Input.is_action_pressed("right"):
		is_flip_h = true
	
	if Input.is_action_pressed("left"):
		is_flip_h = false
		
	flip_h = is_flip_h
	
	#if Input.is_action_just_pressed("click"):
		#self.spawn_enemy_in_random_position()


func spawn_enemy_in_random_position():
	var center = self.position  # Vector inicial
	var radius = self.spawn_raius  # Radio deseado

	# Generar valores aleatorios entre -1 y 1
	var randomX = randf_range(-1, 1)
	var randomY = randf_range(-1, 1)

	# Crear un vector aleatorio
	var randomVector = Vector2(randomX, randomY)

	# Normalizar el vector aleatorio
	randomVector = randomVector.normalized()

	# Multiplicar por el radio
	randomVector *= radius

	# Sumar al vector inicial
	var result = center + randomVector

	self.level.add_virtual_child(SimpleEnemy.new(self.level, result, self))

func fibonacci(n):
	if n <= 0:
		return 0
	elif n == 1:
		return 1
	else:
		var a = 0
		var b = 1
		for i in range(2, n + 1):
			var temp = a + b
			a = b
			b = temp
		return b


func _on_spanw_timer_timeout():
	var result = fibonacci(self.quantity_to_spawn)
	if result >= 300:
		self.quantity_to_spawn = 0
		return
		
	self.quantity_to_spawn += 1
	for i in range(self.quantity_to_spawn):
		self.spawn_enemy_in_random_position()
