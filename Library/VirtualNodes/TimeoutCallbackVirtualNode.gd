class_name TimeoutCallbackVirtualNode
extends BaseVirtualNode2D


var timeout_seconds: float = 0.0
var acumulated_time: float = 0.0
var callback: Callable

func _init(scene: BaseVirtualScene2D, timeout_seconds: float, callback: Callable):
	super._init(scene, null)
	self.timeout_seconds = timeout_seconds
	self.callback = callback
	self.scene.add_subscriber_to_process_event(self)

func process(delta: float):
	if self.acumulated_time >= self.timeout_seconds:
		self.callback.call()
	else:
		self.acumulated_time += delta
