import 'package:flutter/material.dart';

class HalamanHome extends StatelessWidget {
  const HalamanHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ini Halaman Home',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Banyak aplikasi memiliki beberapa layar untuk menampilkan informasi yang berbeda. Contohnya, ada layar produk, dan ketika pengguna mengklik produk, akan muncul layar dengan detail produk tersebut.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 24),
              Center(
                child: Card(
                  elevation: 4, // Memberikan sedikit bayangan
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // Radius sudut tumpul
                  ),
                  color: Colors.white, // Latar belakang putih
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Jarak di dalam card
                    child: Image.asset(
                      'assets/house.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Pertama, kita perlu membuat dua halaman atau "routes" yang ingin kita tampilkan. Selanjutnya, kita gunakan perintah Navigator.push() untuk berpindah dari halaman pertama ke halaman kedua. Ini seperti kita membuka halaman baru. Terakhir, kita bisa kembali dari halaman kedua ke halaman pertama menggunakan Navigator.pop(). Seperti menutup halaman kedua dan kembali ke halaman pertama.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/tujuan');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[600],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Ke halaman tujuan >',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
