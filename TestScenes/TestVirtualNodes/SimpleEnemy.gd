class_name SimpleEnemy
extends PhysicVirtualNode2D

var tarjet: Node2D
var speed = 200

func _init(scene: SimpleTestScene, position: Vector2, tarjet: Node2D):
	super._init(scene, null, position, 50.0)
	
	self.tarjet = tarjet
	
	self.add_child(SpriteVirtualNode2D.new(self.scene, self, scene.enemy_texture, Rect2(0, 0, 100, 100)))

func physics_process(delta: float):
	if position.distance_to(tarjet.position) >= 5:
		position += position.direction_to(tarjet.position) * speed * delta
