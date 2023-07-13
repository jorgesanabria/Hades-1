class_name PhysicVirtualNode2D
extends BaseVirtualNode2D

var radius: float = 0.0

func _init(scene: BaseVirtualScene2D, parent: BaseVirtualNode2D, position: Vector2, radius: float):
	super._init(scene, parent)
	
	self.position = position
	self.radius = radius
	
	self.scene.add_subscriber_to_physics_psocess_event(self)

func physics_process(delta: float):
	pass

func fix_distance(other: PhysicVirtualNode2D):
	var distance = other.position.distance_to(self.position)
	if (other.radius + self.radius) >= distance:
		if !self.is_valid_collision(other):
			return
			
		var separation = (other.radius + self.radius - distance) / 2.0
		var direction = (other.position - self.position).normalized()
		var translation = direction * separation
		self.position -= translation
		other.position += translation
		
		self.on_collisioned(other)

func is_valid_collision(other: PhysicVirtualNode2D) -> bool:
	return true

func on_collisioned(other: PhysicVirtualNode2D):
	pass

func destruct():
	self.scene.queue_remove_subscriber_from_physics_process_event(self)
	super.destruct()
