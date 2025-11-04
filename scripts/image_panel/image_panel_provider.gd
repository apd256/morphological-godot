extends Node

@export var img_path: Image
@export var kernel_size: int = 3

func _ready():
	# TODO: Tambahkan Multithreading
	for i in get_children():
		if i.has_method("process_image"):
			i.call_thread_safe("process_image", img_path, kernel_size)

# func send_image(img: Image):
# 	for i in get_children():
# 		if i.has_method("process_image"):
# 			# i.process_image(img)
# 			i.call_thread_safe("process_image", img)
