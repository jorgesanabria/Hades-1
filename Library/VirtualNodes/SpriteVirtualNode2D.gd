class_name SpriteVirtualNode2D
extends BaseVirtualNode2D

var texture: Texture2D
var rect: Rect2

var sort_order: float = 0.0

func _init(scene: BaseVirtualScene2D, parent: BaseVirtualNode2D, texture: Texture2D, rect: Rect2, sort_order: float = 0.0):
	super._init(scene, parent)
	
	self.texture = texture
	self.rect = rect
	self.sort_order = sort_order
	
	self.scene.add_subscriber_to_draw_event(self)

func destruct():
	self.scene.queue_remove_subscriber_from_draw_event(self)
	super.destruct()

func draw():
	self.scene.draw_set_transform(get_relative_position(), 0.0)
	self.scene.draw_texture_rect(texture, self.rect, false)
	self.scene.draw_set_transform(Vector2.ZERO, 0.0)
