
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

### 2. Penjelasan Fitur Aplikasi

Aplikasi ini adalah platform toko online premium fungsional yang menggabungkan penggunaan data jaringan secara langsung dan sistem penyimpanan basis data lokal.

a. Sumber Data Produk
   Katalog produk ditarik secara dinamis dari eksternal API publik: 
   [https://dummyjson.com/products](https://dummyjson.com/products)

b. Sistem Autentikasi (10 Poin)
   - Akses Wajib: Pengguna yang belum memiliki sesi aktif diwajibkan melewati portal login sebelum mengakses menu utama.
   - Kredensial: Username diinputkan secara bebas, namun Password diwajibkan menggunakan identitas NIM asli Anda.
   - Retensi Sesi: Username aktif disimpan ke dalam cache lokal menggunakan SharedPreferences untuk identifikasi transaksi.

c. Sesi Persisten / Auto-Login (5 Poin)
   - Apabila pengguna menutup aplikasi dan membukanya kembali dalam kondisi belum menekan tombol logout, sistem akan melewati halaman login dan langsung memuat tampilan beranda utama.

d. Struktur Navigasi (5 Poin)
   - Antarmuka utama mengimplementasikan Bottom Navigation Bar yang memuat 2 menu utama: Home dan Profile.

e. Halaman Home (20 Poin)
   - Menampilkan sapaan personal berbasis username aktif.
   - Menyediakan akses cepat menuju halaman Keranjang Belanja (Cart).
   - Menampilkan daftar produk premium dari API. Menekan salah satu kartu produk akan mengarahkan pengguna ke rincian spesifik item tersebut.

f. Halaman Detail Produk (20 Poin)
   - Menyajikan informasi mendalam terkait spesifikasi, harga, dan ketersediaan unit.
   - Dilengkapi panel kuantitas yang membatasi pesanan secara ketat agar tidak melebihi total persediaan stok yang ada.
   - Tombol aksi "Tambah ke Keranjang" akan merekam entitas produk, kuantitas, dan kepemilikan username ke dalam basis data lokal Hive.

g. Halaman Keranjang / Cart (20 Poin)
   - Menampilkan daftar pesanan terenkapsulasi khusus milik pengguna yang sedang aktif.
   - Isolasi Kepemilikan: Sesi milik Username A tidak akan dapat melihat atau mengakses daftar belanjaan yang ditambahkan oleh Username B, begitu pula sebaliknya.
   - Menyediakan opsi pembatalan/penghapusan per item langsung dari memori lokal.

h. Halaman Profile (10 Poin)
   - Menampilkan kartu identitas pengguna aktif.
   - Menyediakan ruang keterangan penugasan responsi.
   - Tombol pemutus sesi (Logout) untuk membersihkan otorisasi dan mengembalikan antarmuka ke halaman awal.
