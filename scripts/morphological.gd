class_name Morphological
extends Node

func segment_image_by_color(img: Image, lower_bound: Color, upper_bound: Color) -> Image:
	var width = img.get_width()
	var height = img.get_height()
	var segmented_img = Image.create_empty(width, height, false, Image.FORMAT_RGBA8)

	for y in range(height):
		for x in range(width):
			var pixel_color = img.get_pixel(x, y)
			if pixel_color >= lower_bound and pixel_color <= upper_bound:
				segmented_img.set_pixel(x, y, pixel_color)
			else:
				segmented_img.set_pixel(x, y, Color(0, 0, 0, 0))

	return segmented_img


# --------------------------------------------------------------
func create_square_kernel(size: int = 3) -> PackedInt32Array:
	var k := PackedInt32Array()
	for _y in size:
		for _x in size:
			k.append(1)

	return k


# --------------------------------------------------------------
func _apply_morphology(
		src_img: Image,
		kernel: PackedInt32Array,
		kernel_w: int,
		kernel_h: int,
		mode: String,
) -> Image:
	var dst := Image.create(
		src_img.get_width(),
		src_img.get_height(),
		false,
		src_img.get_format(),
	)

	var half_w := kernel_w / 2
	var half_h := kernel_h / 2

	for y in src_img.get_height():
		for x in src_img.get_width():
			var keep := (mode == "erode")

			# walk through the kernel
			for ky in kernel_h:
				for kx in kernel_w:
					var idx := ky * kernel_w + kx
					if kernel[idx] == 0:
						continue

					var sx := x + kx - half_w
					var sy := y + ky - half_h

					if sx < 0 or sy < 0 or sx >= src_img.get_width() or sy >= src_img.get_height():
						if mode == "erode":
							keep = false
						continue

					var pixel_val := src_img.get_pixel(sx, sy).r

					if mode == "erode":
						if pixel_val == 0.0:
							keep = false
							break
					else:
						if pixel_val > 0.0:
							keep = true
							break
				if (mode == "erode" and not keep) or (mode == "dilate" and keep):
					break

			var out_color := Color.WHITE if keep else Color.BLACK
			dst.set_pixel(x, y, out_color)

	return dst


# --------------------------------------------------------------
func erode(src_img: Image, kernel: PackedInt32Array, kw: int, kh: int) -> Image:
	return _apply_morphology(src_img, kernel, kw, kh, "erode")


func dilate(src_img: Image, kernel: PackedInt32Array, kw: int, kh: int) -> Image:
	return _apply_morphology(src_img, kernel, kw, kh, "dilate")


func opening(src_img: Image, kernel: PackedInt32Array, kw: int, kh: int) -> Image:
	var img_result = src_img
	img_result = erode(img_result, kernel, kw, kh)
	img_result = dilate(img_result, kernel, kw, kh)
	return img_result


func closing(src_img: Image, kernel: PackedInt32Array, kw: int, kh: int) -> Image:
	var img_result = src_img
	img_result = dilate(img_result, kernel, kw, kh)
	img_result = erode(img_result, kernel, kw, kh)
	return img_result
