class_name SoundManager extends Node

var num_players: int = 8
var bus: String = "Master"

var available_stream_player: Array[AudioStreamPlayer] = []
var queue: Array[QueuedSound] = []

static var instance: SoundManager

func _ready():
	instance = self
	
	# Pool some audio stream players
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available_stream_player.append(p)
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = bus

func _on_stream_finished(stream):
	# Stream finished, so add it back to the available stream players
	available_stream_player.append(stream)

func play(sound: AudioStream, pitch: float = 1.0):
	var qs = QueuedSound.new()
	qs.sound = sound
	qs.pitch = pitch
	queue.append(qs)

func _process(_delta):
	# Play the next sound in the queue, if a stream player is available
	if not queue.is_empty() and not available_stream_player.is_empty():
		var qs = queue.pop_front() #load(queue.pop_front())
		available_stream_player[0].stream = qs.sound
		available_stream_player[0].pitch_scale = qs.pitch
		available_stream_player[0].play()
		available_stream_player.pop_front()
