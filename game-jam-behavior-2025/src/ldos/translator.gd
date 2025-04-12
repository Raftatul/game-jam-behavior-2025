extends PathFollow3D

@export var speed:float = 1
@export var duration:float = 1
@export var movement_type:MovementType = MovementType.PROGRESS
@export var pingpong_movement:bool = true
@export var pause_at_extrimity:bool = false
@export var pause_duration:float = 1.0

var moving_forward:bool = true
enum MovementType {PROGRESS,RATIO}

func _ready() -> void:
	$Timer.wait_time = pause_duration

func _process(delta: float) -> void:
	
	if(!$Timer.is_stopped()):
		return
	
	match movement_type:
		MovementType.PROGRESS:
			if(moving_forward): self.progress += speed * delta
			else : self.progress -= speed * delta
		MovementType.RATIO:
			if(moving_forward): self.progress_ratio += 1.0 / duration * delta
			else: self.progress_ratio -= 1.0 / duration * delta
	
	if (self.progress_ratio >= 1.0):
		moving_forward = false
		if(pause_at_extrimity):$Timer.start()
	elif (self.progress_ratio <= 0.0):
		moving_forward= true
		if(pause_at_extrimity):$Timer.start()
