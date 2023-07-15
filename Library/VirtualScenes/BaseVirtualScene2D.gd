class_name BaseVirtualScene2D
extends Node2D

#childrem nodes
var virtual_childrem: Array[BaseVirtualNode2D] = []
var virtual_childrem_to_remove: Array[BaseVirtualNode2D] = []

#subscriptors
var subscribers_to_process_event: Array[BaseVirtualNode2D] = []
var subscribers_to_physics_process_event: Array[BaseVirtualNode2D] = []
var subscribers_to_draw_event: Array[BaseVirtualNode2D] = []

var subscribers_to_remove_from_process_event: Array[BaseVirtualNode2D] = []
var subscribers_to_remove_from_physics_process_event: Array[BaseVirtualNode2D] = []
var subscribers_to_remove_from_draw_event: Array[BaseVirtualNode2D] = []

func queue_destroy_virtual_child(child: BaseVirtualNode2D):
	self.virtual_childrem_to_remove.append(child)

func _process(delta):
	self.clear_childrem_to_remove()
	self.clear_desubscriptions()
	for subscriber in self.subscribers_to_process_event:
		subscriber.call("process", delta)
		
	queue_redraw()

func _physics_process(delta):
	for subscriber in self.subscribers_to_physics_process_event:
		subscriber.call("physics_process", delta)
	self.fix_distances()
	
func fix_distances():
	var i = 0;
	while i < self.subscribers_to_physics_process_event.size():
		var j = i + 1
		while j < self.subscribers_to_physics_process_event.size():
			self.subscribers_to_physics_process_event[i].call("fix_distance", self.subscribers_to_physics_process_event[j])
			j += 1
		i += 1
	
func _draw():
	for subscriber in self.subscribers_to_draw_event:
		subscriber.call("draw")

func clear_desubscriptions_to_process():
	for process_subscriber in self.subscribers_to_remove_from_process_event:
		if self.subscribers_to_process_event.has(process_subscriber):
			self.subscribers_to_process_event.remove_at(self.subscribers_to_process_event.find(process_subscriber))
	self.subscribers_to_remove_from_process_event.clear()

func clear_desubscriptions_to_physics_process():
	for physics_process_subscriber in self.subscribers_to_remove_from_physics_process_event:
		if self.subscribers_to_physics_process_event.has(physics_process_subscriber):
			self.subscribers_to_physics_process_event.remove_at(self.subscribers_to_physics_process_event.find(physics_process_subscriber))
	self.subscribers_to_remove_from_physics_process_event.clear()

func clear_desubscriptions_to_draw():
	for draw_subscriber in self.subscribers_to_remove_from_draw_event:
		if self.subscribers_to_draw_event.has(draw_subscriber):
			self.subscribers_to_draw_event.remove_at(self.subscribers_to_draw_event.find(draw_subscriber))
	self.subscribers_to_remove_from_draw_event.clear()

func clear_childrem_to_remove():
	for child_to_remove in self.virtual_childrem_to_remove:
		if self.virtual_childrem.has(child_to_remove):
			self.virtual_childrem.remove_at(self.virtual_childrem.find(child_to_remove))
			child_to_remove.destruct()
	self.virtual_childrem_to_remove.clear()

func clear_desubscriptions():
	self.clear_desubscriptions_to_process()
	self.clear_desubscriptions_to_physics_process()
	self.clear_desubscriptions_to_draw()
	

func add_subscriber_to_process_event(subscriber: BaseVirtualNode2D):
	self.subscribers_to_process_event.append(subscriber)
func queue_remove_subscriber_from_process_event(subscriber: BaseVirtualNode2D):
	self.subscribers_to_process_event.append(subscriber)

func add_subscriber_to_physics_psocess_event(subscriber: BaseVirtualNode2D):
	self.subscribers_to_physics_process_event.append(subscriber)
func queue_remove_subscriber_from_physics_process_event(subscriber: BaseVirtualNode2D):
	self.subscribers_to_remove_from_physics_process_event.append(subscriber)

func add_subscriber_to_draw_event(subscriber: BaseVirtualNode2D):
	self.subscribers_to_draw_event.append(subscriber)
	self.subscribers_to_draw_event.sort_custom(func(a, b): return a.get("sort_order") < b.get("sort_order"))
func queue_remove_subscriber_from_draw_event(subscriber: BaseVirtualNode2D):
	self.subscribers_to_remove_from_draw_event.append(subscriber)

func add_virtual_child(child: BaseVirtualNode2D):
	if child in self.virtual_childrem:
		return
	
	self.virtual_childrem.append(child)

func get_closest_childrem(point:Vector2, max_count: int, condition: Callable) -> Array[BaseVirtualNode2D]:
	#if self.virtual_childrem.size() <= 1:
		#return []
	
	var childrem: Array[BaseVirtualNode2D] = []
	
	var i = 0
	while i <= max_count:
		var child = get_closest_virtual_node(point, condition)
		if child == null:
			break
		#if condition.call(child):
		if child not in childrem:
			childrem.append(child)
		
		#if (self.virtual_childrem.size() - 1) == i:
			#break
		
		i += 1
	
	return childrem

func get_closest_nodes(origin: Vector2, filter: Callable, max_count: float = 1.0) -> Array[BaseVirtualNode2D]:
	var closest_nodes: Array[BaseVirtualNode2D] = []
	var filter_nodes := self.virtual_childrem.filter(filter)
	for i in range(filter_nodes.size()):
		var distance = filter_nodes[i].position.distance_to(origin)
		if closest_nodes.size() < max_count:
			closest_nodes.append(filter_nodes[i])
		else:
			for j in range(max_count):
				if distance < closest_nodes[j].position.distance_to(origin):
					closest_nodes[j] = filter_nodes[i]
					break
	return closest_nodes	

func get_closest_virtual_node(origin: Vector2, filter: Callable) -> BaseVirtualNode2D:
	var closest_index = -1
	var shortest_distance = 9999999
	for i in range(self.virtual_childrem.filter(filter).size()):
		var distance = self.virtual_childrem[i].distance_to(origin)
		if distance < shortest_distance:
			shortest_distance = distance
			closest_index = i
	if closest_index >= 0:
		return self.virtual_childrem[closest_index]
	
	return null


func get_closest_child(point: Vector2, condition: Callable, childrem_to_ignore: Array[BaseVirtualNode2D] = []) -> BaseVirtualNode2D:
	if self.virtual_childrem.size() == 0:
		return null
		
	var closest_child: BaseVirtualNode2D = self.virtual_childrem[0]
	
	for child in self.virtual_childrem.filter(condition):
		if child in childrem_to_ignore:
			continue
		
		if child == closest_child:
			continue
			
		if child.position.distance_to(point) < closest_child.position.distance_to(point):
			closest_child = child
		
	return closest_child	
