class_name SpriteBullet
extends SpriteVirtualNode2D

var direction: Vector2
var speed = 500

func _init(scene: BaseVirtualScene2D, texture: Texture2D, origin: Vector2, tarjet: Vector2):
	super._init(scene, null, texture, Rect2(0, 0, 50, 50), 0.0)
	
	self.position = origin
	self.direction = (tarjet - origin).normalized()
	
	self.scene.add_subscriber_to_process_event(self)

func process(delta: float):
	self.position += self.direction * speed * delta
