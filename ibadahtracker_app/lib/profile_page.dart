// profile_page.dart (SUDAH DIMODIFIKASI)

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final Map<String, Map<String, dynamic>> prayerStatus;
  final int fastingDays;
  final Function(int) updateFastingDays;
  final int readSurahCount;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.prayerStatus,
    required this.fastingDays,
    required this.updateFastingDays,
    required this.readSurahCount,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedPrayers = widget.prayerStatus.values
        .where((data) => data['status'] == true)
        .length;
    final totalPrayers = widget.prayerStatus.length;

    // --- PERUBAHAN 1: Menghitung lebar kartu ---
    // Kita hitung lebar kartu agar konsisten seperti GridView
    // Lebar layar - (padding kiri & kanan) - (spasi tengah) / 2
    final cardWidth = (MediaQuery.of(context).size.width - (16 * 2) - 12) / 2;
    // --- BATAS PERUBAHAN 1 ---

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.userName,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${widget.userName.toLowerCase()}@ibadah.com',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- PERUBAHAN 2: Mengganti GridView menjadi Column/Row ---
            // Stats Layout
            Column(
              children: [
                // Baris pertama (2 kartu)
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Sholat Wajib',
                        '$completedPrayers/$totalPrayers',
                        Icons.mosque,
                      ),
                    ),
                    const SizedBox(width: 12), // Spasi antar kartu
                    Expanded(
                      child: _buildStatCard(
                        'Hari Puasa',
                        '${widget.fastingDays} Hari',
                        Icons.calendar_month,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12), // Spasi antar baris

                // Baris kedua (1 kartu di tengah)
                Center(
                  child: SizedBox(
                    width: cardWidth, // Gunakan lebar yang sudah dihitung
                    child: _buildStatCard(
                      'Baca Quran',
                      '${widget.readSurahCount} Surah',
                      Icons.menu_book,
                    ),
                  ),
                ),
              ],
            ),
            // --- BATAS PERUBAHAN 2 ---

            const SizedBox(height: 24),

            // Rekap Catatan Sholat
            _buildPrayerNotesCard(),

            const SizedBox(height: 16),
            // Footer/Quote
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(Icons.format_quote, color: Colors.blue),
                  SizedBox(height: 8),
                  Text(
                    '\"Sebaik-baik manusia adalah yang paling bermanfaat bagi orang lain\"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // (Fungsi _buildPrayerNotesCard tetap sama)
  Widget _buildPrayerNotesCard() {
    final notes = widget.prayerStatus.entries
        .where((entry) => entry.value['note'].isNotEmpty)
        .toList();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rekap Catatan Sholat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (notes.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Belum ada catatan.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Column(
                children: notes.map((entry) {
                  final prayerName = entry.key;
                  final data = entry.value;
                  final bool isDone = data['status'];
                  final String note = data['note'];

                  return ListTile(
                    dense: true,
                    leading: Icon(
                      isDone ? Icons.check_circle_outline : Icons.highlight_off,
                      color: isDone ? Colors.green : Colors.red,
                    ),
                    title: Text(prayerName),
                    subtitle: Text(note),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  // (Fungsi _buildStatCard tetap sama)
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        // --- PERUBAHAN 3: Atur aspect ratio agar tinggi kartu konsisten ---
        child: AspectRatio(
          aspectRatio: 1.5, // Rasio yang sama dengan GridView sebelumnya
          // --- BATAS PERUBAHAN 3 ---
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: const Color(0xFF2E7D32),
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
