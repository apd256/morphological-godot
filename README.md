# Morphological Filtering

Project ini dibuat melalui aplikasi Godot Engine (versi 4.5.1)
menggunakan GDScript. Untuk menjalankannya dapat diakses melalui tautan berikut.

https://godotengine.org

## Pembahasan

Pada project ini diimplementasikan dua tahap dalam memproses citra digital yaitu
segmentasi dan morfologi. Pada tahap segmentasi, metode yang digunakan adalah Otsu.
Sedangkan pada tahap morfologi, terdapat empat metode yang dilakukan setelah gambar
tersebut disegmentasi yaitu, erosi (erosion), dilasi (dilation), pembukaan (opening) 
dan penutupan (closing).

Ketika pengguna/pemain menjalankan aplikasi ini, mereka akan ditempatkan 
pada sebuah tempat (*level*/*scene* dalam istilah *video game*) dimana terdapat
tiga sampel gambar yang sedang diproses pada *thread* utama. Oleh karena itu,
pengguna/pemain tidak dapat secara langsung dapat berinteraksi dengan tempat tersebut.
Pengguna dapat menggerakkan karakternya menggunakan **WASD** dan *Mouse*.