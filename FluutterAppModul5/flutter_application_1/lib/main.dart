import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData.dark(), // a. Tampilan gelap elegan
      home: const MusicPlayerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sedang memutar"),
        centerTitle: true, // b. Judul di tengah
      ),
      body: Center(
        // c. Card di tengah layar
        child: Container(
          width: double.infinity,
          child: Card(
            elevation: 4, // d.1 Elevation
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Rectangular shape
            ),
            child: Padding(
              padding: const EdgeInsets.all(12), // d.3 Padding dalam Card
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.album, size: 100, color: Colors.grey),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Di Akhir Perang",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Nadin Amizah",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
