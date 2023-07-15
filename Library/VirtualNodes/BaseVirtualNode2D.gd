class_name BaseVirtualNode2D
extends Object

var scene: BaseVirtualScene2D
var parent: BaseVirtualNode2D = null
var position: Vector2 = Vector2.ZERO
var groups: Array[String] = []
var name: String = ""
var chilrem: Array[BaseVirtualNode2D] = []

func get_relative_position() -> Vector2:
	if parent == null:
		return self.position
	
	return self.parent.position + self.position

func _init(scene: BaseVirtualScene2D, parent: BaseVirtualNode2D, groups: Array[String] = []):
	self.scene = scene
	self.groups = groups
	self.parent = parent

func add_child(node: BaseVirtualNode2D):
	if node in self.chilrem:
		return
	
	self.chilrem.append(node)

func queue_destroy():
	self.scene.queue_destroy_virtual_child(self)

func destruct():
	for child in self.chilrem:
		child.destruct()
