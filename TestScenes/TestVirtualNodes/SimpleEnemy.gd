class_name SimpleEnemy
extends PhysicVirtualNode2D

var tarjet: Node2D
var speed = 400
#var rect = Rect2(0, 0, 100, 100)
var child: SpriteVirtualNode2D

func _init(scene: SimpleTestScene, position: Vector2, tarjet: Node2D):
	super._init(scene, null, position, 50.0)
	self.name = "enemy"
	self.tarjet = tarjet
	
	self.child = SpriteVirtualNode2D.new(self.scene, self, scene.enemy_texture, Rect2(0, 0, 100, 100))
	self.add_child(self.child)

func physics_process(delta: float):
	if position.distance_to(tarjet.position) >= 5:
		position += position.direction_to(tarjet.position) * speed * delta
		
	if self.position.x < self.tarjet.position.x:
		self.child.rect = Rect2(0, 0, 100, 100)
	elif self.position.x > self.tarjet.position.x:
		self.child.rect = Rect2(0, 0, -100, 100)

func is_valid_collision(other: PhysicVirtualNode2D) -> bool:
	if other is SimpleBullet:
		queue_destroy()
		
	return true
