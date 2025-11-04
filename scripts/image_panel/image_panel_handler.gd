extends Node

var _mp = preload("res://scripts/morphological.gd").new()
var _sm = preload("res://scripts/segmentation.gd").new()

# Objek dalam GUI
@onready var texture_rect = $SubViewport/CenterContainer/VBoxContainer/TextureRect
@onready var img_label = $FilterLabel

enum MP_TYPE { ORIGINAL, SEGMENTED, ERODE, DILATE, OPENING, CLOSING }

var img_thread = Thread.new()

# Anotasi @export artinya konfigurasi ini dapat diubah melalui antarmuka Godot
@export var img_path: Image
@export var img_process: MP_TYPE
#@export var kernel_size: int = 3


func process_image(img: Image, kernel_size: int):
	if img != null:
		# Mengubah gambar menjadi format *grayscale*
		img.convert(Image.FORMAT_L8)

		# Membuat kernel sesuai dengan nilai variabel *kernel_size*
		var kernel := _mp.create_square_kernel(kernel_size)

		var img_result: ImageTexture = null

		# Mengaplikasikan metode otsu untuk segmentasi
		var img_otsu = _sm.otsu_threshold(img)
		var img_segmented = _sm.apply_threshold(img, img_otsu)

		# Melakukan pemilihan process gambar
		match img_process:
			MP_TYPE.ORIGINAL:
				texture_rect.texture = ImageTexture.create_from_image(img)
				img_label.text = "Original"
			MP_TYPE.SEGMENTED:
				texture_rect.texture = ImageTexture.create_from_image(img_segmented)
				img_label.text = "Segmented (Otsu)"
			MP_TYPE.ERODE:
				img_result = ImageTexture.create_from_image(_mp.erode(img, kernel, kernel_size, kernel_size))
				texture_rect.texture = img_result
				img_label.text = "Erosion"
			MP_TYPE.DILATE:
				img_result = ImageTexture.create_from_image(_mp.dilate(img, kernel, kernel_size, kernel_size))
				texture_rect.texture = img_result
				img_label.text = "Dilation"
			MP_TYPE.OPENING:
				img_result = ImageTexture.create_from_image(_mp.opening(img, kernel, kernel_size, kernel_size))
				texture_rect.texture = img_result
				img_label.text = "Opening"
			MP_TYPE.CLOSING:
				img_result = ImageTexture.create_from_image(_mp.closing(img, kernel, kernel_size, kernel_size))
				texture_rect.texture = img_result
				img_label.text = "Closing"
	else:
		printerr("Mohon masukkan gambar yang valid")
