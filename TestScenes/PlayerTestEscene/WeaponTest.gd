extends Node2D

@export var bullet_texture: Texture2D

var level: BaseVirtualScene2D

var sprite: Sprite2D

var must_fire_from_firts_canyon = true

func _ready():
	self.sprite = get_parent() as Sprite2D

func _process(delta):
	self.update_scale()
	
	if Input.is_action_just_pressed("click"):
		self.fire()

func fire():
	if self.must_fire_from_firts_canyon:
		self.do_fire($BottonCanyon.global_position)
		self.must_fire_from_firts_canyon = false
	else:
		self.do_fire($TopCanyon.global_position)
		self.must_fire_from_firts_canyon = true


func do_fire(from: Vector2):
	#print(self.sprite.position)
	#print(from)
	var to_fire = self.level.get_closest_childrem(from, 1, func(obj) -> bool: return obj is SimpleEnemy)
	
	for enemy in to_fire:
		#print(enemy is SimpleEnemy)
		self.level.add_virtual_child(SimpleBullet.new(self.level, self.bullet_texture, from, enemy.position))

func set_level(level: BaseVirtualScene2D):
	self.level = level
	
func update_scale():
	if self.sprite.flip_h:
		self.scale.x = -1
	else:
		self.scale.x = 1
