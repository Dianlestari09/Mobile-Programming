# IbadahTracker App

IbadahTracker App adalah aplikasi mobile yang dikembangkan menggunakan Flutter untuk membantu pengguna Muslim dalam memantau dan mencatat aktivitas ibadah harian mereka. Aplikasi ini dirancang dengan antarmuka yang bersih dan intuitif agar mudah digunakan.

## Tema dan Tujuan Aplikasi

Di tengah kesibukan sehari-hari, seringkali sulit untuk konsisten dalam memantau pelaksanaan ibadah wajib dan sunnah. Tujuan utama dari aplikasi ini adalah untuk menyediakan alat bantu digital yang praktis bagi pengguna untuk:
- Melacak pelaksanaan sholat lima waktu.
- Mencatat puasa yang dijalankan.
- Menandai progres bacaan Al-Quran.
- Memberikan rekapitulasi aktivitas ibadah untuk evaluasi diri.

## Daftar Halaman dan Fungsinya

Aplikasi ini terdiri dari beberapa halaman utama:

1.  **Halaman Login (`login_page.dart`):** Halaman awal tempat pengguna masuk ke dalam aplikasi. Menggunakan email (sebagai nama pengguna) dan password sederhana.
2.  **Halaman Utama/Menu (`main_menu.dart`):** Berfungsi sebagai dasbor utama setelah login. Menampilkan jadwal sholat harian, grid untuk melacak sholat lima waktu, serta menu navigasi ke fitur Al-Quran dan Puasa.
3.  **Halaman Al-Quran (`quran_page.dart`):** Menampilkan daftar 114 surah dalam Al-Quran yang diambil dari API. Pengguna dapat mencari surah dan melihat detail ayat (teks Arab dan terjemahan Indonesia).
4.  **Halaman Puasa (`puasa_page.dart`):** Berisi kalender interaktif yang memungkinkan pengguna untuk menandai hari-hari saat mereka berpuasa sunnah maupun wajib.
5.  **Halaman Profil (`profile_page.dart`):** Menampilkan rekapitulasi data ibadah pengguna, seperti jumlah sholat yang dikerjakan, total hari puasa, dan jumlah surah yang telah dibaca. Pengguna juga dapat mengubah foto profil dan keluar dari aplikasi.

## Langkah Menjalankan Aplikasi

1.  Pastikan Anda telah menginstal Flutter SDK di komputer Anda.
2.  Clone repositori ini: `git clone [URL_GITHUB_ANDA]`
3.  Pindah ke direktori proyek: `cd ibadahtracker_app`
4.  Jalankan perintah untuk mengunduh dependensi: `flutter pub get`
5.  Hubungkan perangkat (emulator atau perangkat fisik).
6.  Jalankan aplikasi dengan perintah: `flutter run`
