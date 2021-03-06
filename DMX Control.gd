extends Node

var peer: PacketPeerUDP

# Called when the node enters the scene tree for the first time.
func _ready():
	peer = PacketPeerUDP.new()
	peer.connect_to_host("127.0.0.1", 7700)

func call_alarm():
	_send_packet("/alarm", 255)

func set_color(number: int, color: Color):
	_send_packet("/field/%s/r" % number, color.r8)
	_send_packet("/field/%s/g" % number, color.g8)
	_send_packet("/field/%s/b" % number, color.b8)

func _send_packet(addr: String, value: int):
	print("Sending packet ", addr, " ", value)
	var buffer = _encode_string(addr)
	buffer.append(0)
	buffer.append_array(_encode_string(",i"))
	buffer.append(0)
	buffer.append_array(PoolByteArray([0, 0, 0, value]))
	print("Buffer", buffer as Array)
	peer.put_packet(buffer)

func _encode_string(text: String) -> PoolByteArray:
	var buffer = text.to_ascii()
	buffer.append(0)
	_pad_addr(buffer)
	return buffer

func _pad_addr(buffer: PoolByteArray):
	var length = _get_padded_addr_length(buffer.size())
	while (buffer.size() < length):
		buffer.append(0)

func _get_padded_addr_length(length: int) -> int:
	var reminder = length % 4
	if reminder == 0:
		return length
	else:
		return length + (4 - reminder)
