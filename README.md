
```markdown
## Struktur Direktori Proyek

```text
lib/
│
├── main.dart                   # Titik masuk utama aplikasi & inisialisasi Hive
├── models/                     # Representasi objek data
│   ├── product_model.dart      # Model pemetaan JSON produk dari API eksternal
│   └── cart_item_model.dart    # Model objek keranjang dan TypeAdapter Hive
├── services/                   # Lapisan logika bisnis dan komunikasi eksternal
│   ├── api_service.dart        # Layanan HTTP request ke DummyJSON API
│   ├── auth_service.dart       # Layanan autentikasi & sesi (SharedPreferences)
│   └── hive_service.dart       # Layanan penyimpanan persisten keranjang belanja
└── views/                      # Lapisan antarmuka pengguna (UI)
    ├── login_page.dart         # Halaman masuk dengan validasi NIM
    ├── main_page.dart          # Kerangka Bottom Navigation Bar
    ├── home_page.dart          # Halaman beranda daftar produk API
    ├── detail_page.dart        # Halaman informasi produk & penambahan kuantitas
    ├── cart_page.dart          # Halaman keranjang belanja spesifik pengguna
    └── profile_page.dart       # Halaman profil pengguna aktif & tombol keluar

```

```

---

### 2. Penjelasan Aplikasi yang Harus Dibuat
Aplikasi ini pada dasarnya adalah platform toko online fungsional yang menggabungkan penggunaan *state* jaringan dan *database* lokal. Berikut adalah penjabaran alur dan spesifikasi fiturnya sesuai instruksi soal:

* **Sumber Data Produk:** Katalog produk yang ditampilkan aplikasi harus ditarik secara dinamis dari API eksternal publik: `https://dummyjson.com/products`.
* **Sistem Autentikasi (10 Poin):**
  * Sebelum mengakses aplikasi, pengguna yang belum memiliki sesi login wajib melewati halaman Login.
  * **Aturan Login:** Pengguna bebas memasukkan *username* apa saja, namun **password wajib menggunakan NIM Anda**.
  * *Username* yang berhasil diotentikasi harus disimpan ke dalam *session* (menggunakan `SharedPreferences`) untuk digunakan sebagai pengenal identitas di halaman lain.
* **Retensi Sesi / *Auto-Login* (5 Poin):**
  * Jika pengguna menutup aplikasi lalu membukanya kembali dalam kondisi sudah pernah login (belum menekan tombol *logout*), sistem harus langsung mengarahkannya ke halaman utama tanpa meminta login ulang.
* **Navigasi Utama (5 Poin):**
  * Halaman utama wajib mengimplementasikan 2 menu pada *Bottom Navigation Bar*, yaitu **Home** dan **Profile**.
* **Halaman Home (20 Poin):**
  * Menampilkan informasi *username* pengguna yang saat ini sedang aktif.
  * Menyediakan tombol aksi menuju halaman **Cart** (Keranjang).
  * Merender daftar produk yang didapatkan dari API. Jika salah satu item produk ditekan, aplikasi akan melakukan navigasi ke halaman **Detail Produk** dari item yang bersangkutan.
* **Halaman Detail Produk (20 Poin):**
  * Menampilkan seluruh informasi terperinci dari produk yang dipilih.
  * Menyediakan kontrol antarmuka untuk menambah atau mengurangi jumlah barang (*quantity*) dengan batasan matematis ketat: $0 < \text{qty} \le \text{totalQty}$ (ketersediaan stok).
  * Terdapat tombol **Add to Cart**. Saat ditekan, data produk, identitas *username* yang menekan, dan jumlah *quantity* akan direkam secara persisten ke dalam *local database* **Hive**.
* **Halaman Cart (20 Poin):**
  * Menampilkan daftar belanjaan yang spesifik dimiliki oleh *user* aktif.
  * **Isolasi Data:** Jika *username* A memasukkan produk $x$ dan $y$, maka keranjang hanya menampilkan $x$ dan $y$. Apabila akun di-*logout* dan berganti masuk menggunakan *username* B, isi keranjang harus berubah menyesuaikan data yang sebelumnya dimasukkan oleh akun B.
  * Setiap baris item di keranjang wajib dilengkapi dengan tombol aksi untuk menghapus produk tersebut dari *database* lokal.
* **Halaman Profile (10 Poin):**
  * Menampilkan kembali informasi *username* yang sedang login.
  * Menyediakan ruang teks deskripsi (bebas diisi catatan atau informasi tambahan apa pun).
  * Terdapat tombol **Logout** untuk menghapus sesi dan mengembalikan pengguna ke halaman Login.

```
