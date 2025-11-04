extends Node

func compute_histogram(img: Image) -> PackedInt32Array:
	var hist = PackedInt32Array()
	hist.resize(256)
	hist.fill(0)

	for y in range(img.get_height()):
		for x in range(img.get_width()):
			var intensity = int(img.get_pixel(x, y).r * 255.0)
			hist[intensity] += 1
	return hist


func otsu_threshold(img: Image) -> int:
	var hist = compute_histogram(img)
	var total = img.get_width() * img.get_height()

	var sum_total = 0.0
	for i in range(256):
		sum_total += i * hist[i]

	var sumB = 0.0
	var wB = 0.0
	var wF = 0.0
	var var_max = 0.0
	var threshold = 0

	for i in range(256):
		wB += hist[i]
		if wB == 0:
			continue
		wF = total - wB
		if wF == 0:
			break
		sumB += i * hist[i]
		var mB = sumB / wB
		var mF = (sum_total - sumB) / wF
		var var_between = wB * wF * pow((mB - mF), 2)

		if var_between > var_max:
			var_max = var_between
			threshold = i
	return threshold


func apply_threshold(img: Image, threshold: int) -> Image:
	var segmented = Image.create_empty(img.get_width(), img.get_height(), false, Image.FORMAT_L8)

	for y in range(img.get_height()):
		for x in range(img.get_width()):
			var intensity = int(img.get_pixel(x, y).r * 255.0)
			var value = 1.0 if intensity > threshold else 0.0
			segmented.set_pixel(x, y, Color(value, value, value))

	return segmented
