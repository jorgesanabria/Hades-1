class_name PlayerCollider
extends PhysicVirtualNode2D

var player: Node2D

func _init(scene: BaseVirtualScene2D, player: Node2D):
	super._init(scene, null, get_corrected_position(player.global_position), 100.0)
	self.player = player
	self.name = "player_collider"

func physics_process(delta: float):
	self.position = get_corrected_position(self.player.global_position)

func get_corrected_position(initial: Vector2) -> Vector2:
	return initial - Vector2(35, 35)


func is_valid_collision(other: PhysicVirtualNode2D) -> bool:
	if other is SimpleBullet:
		return false
	
	return false
