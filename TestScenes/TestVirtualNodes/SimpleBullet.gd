class_name SimpleBullet
extends PhysicVirtualNode2D

var speed = 500.0
var tarjet: Vector2
var velocity: Vector2

func _init(scene: SimpleTestScene, texture: Texture2D, position: Vector2, tarjet: Vector2):
	super._init(scene, null, position, 50.0)
	self.add_child(SpriteVirtualNode2D.new(self.scene, self, texture, Rect2(0, 0, 20, 20)))
	self.add_child(TimeoutCallbackVirtualNode.new(self.scene, 2.0, func(): self.queue_destroy()))
	self.name = "bullet"
	self.tarjet = tarjet
	self.velocity = (tarjet - position).normalized()

func physics_process(delta: float):
	self.position += velocity * speed * delta

func is_valid_collision(other: PhysicVirtualNode2D) -> bool:
	if other is SimpleEnemy:
		queue_destroy()
		return true
	
	return false
