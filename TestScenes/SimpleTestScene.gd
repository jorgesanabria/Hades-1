class_name SimpleTestScene
extends BaseVirtualScene2D

@export var enemy_texture: Texture2D
@export var tarjet_path: NodePath

func _ready():
	for i in range(250):
		self.add_virtual_child(SimpleEnemy.new(self, Vector2(100, 100) * i, get_node(self.tarjet_path)))

