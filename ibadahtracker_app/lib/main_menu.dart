// main_menu.dart (SUDAH DIMODIFIKASI)

import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'puasa_page.dart';
import 'quran_page.dart';
import 'api_service.dart';

class MainMenu extends StatefulWidget {
  final String userName;

  const MainMenu({super.key, required this.userName});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  // Data status sholat (sudah dengan catatan)
  Map<String, Map<String, dynamic>> prayerStatus = {
    'Shubuh': {'status': false, 'note': ''},
    'Dzuhur': {'status': false, 'note': ''},
    'Ashar': {'status': false, 'note': ''},
    'Maghrib': {'status': false, 'note': ''},
    'Isya': {'status': false, 'note': ''},
  };

  Map<String, String> prayerTimes = {
    'Shubuh': '04:30',
    'Dzuhur': '12:15',
    'Ashar': '15:30',
    'Maghrib': '18:00',
    'Isya': '19:20',
  };

  int fastingDays = 0;
  bool _isLoading = true;
  final Future<Map<String, dynamic>> _dailyVerse =
      QuranApiService.getDailyVerse();

  // --- PERUBAHAN 1: Variabel baru untuk melacak Surah yang sudah dibaca ---
  // Kita menggunakan Set<int> agar setiap nomor surah hanya tersimpan satu kali (unik)
  final Set<int> _readSurahNumbers = {};
  // --- BATAS PERUBAHAN 1 ---

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    setState(() {
      _isLoading = true;
    });

    final times = await ApiService.getPrayerTimes();

    setState(() {
      prayerTimes = times;
      _isLoading = false;
    });
  }

  // (Fungsi _showPrayerDialog tetap sama, tidak perlu diubah)
  Future<void> _showPrayerDialog(String prayerName) async {
    final TextEditingController noteController =
        TextEditingController(text: prayerStatus[prayerName]!['note']);
    bool? dialogStatus = prayerStatus[prayerName]!['status'];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Catatan Sholat $prayerName'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<bool>(
                      title: const Text('Selesai'),
                      value: true,
                      groupValue: dialogStatus,
                      onChanged: (value) {
                        setDialogState(() {
                          dialogStatus = value;
                        });
                      },
                    ),
                    RadioListTile<bool>(
                      title: const Text('Tidak'),
                      value: false,
                      groupValue: dialogStatus,
                      onChanged: (value) {
                        setDialogState(() {
                          dialogStatus = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: noteController,
                      decoration: const InputDecoration(
                        labelText: 'Catatan (opsional)',
                        hintText:
                            'Misal: Tepat waktu, di masjid, ada hambatan...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      prayerStatus[prayerName]!['status'] =
                          dialogStatus ?? false;
                      prayerStatus[prayerName]!['note'] = noteController.text;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          userName: widget.userName,
          prayerStatus: prayerStatus,
          fastingDays: fastingDays,
          // --- PERUBAHAN 2: Kirim JUMLAH surah yang sudah dibaca ---
          readSurahCount: _readSurahNumbers.length,
          // --- BATAS PERUBAHAN 2 ---
          updateFastingDays: (days) {
            setState(() {
              fastingDays = days;
            });
          },
        ),
      ),
    );
  }

  void _navigateToQuran() {
    Navigator.push(
      context,
      MaterialPageRoute(
        // --- PERUBAHAN 3: Kirim FUNGSI callback ke QuranPage ---
        // Ini agar QuranPage bisa memberitahu MainMenu jika ada surah yang dibaca
        builder: (context) => QuranPage(
          onSurahRead: (surahNumber) {
            setState(() {
              _readSurahNumbers.add(surahNumber);
            });
          },
        ),
        // --- BATAS PERUBAHAN 3 ---
      ),
    );
  }

  void _navigateToPuasa() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PuasaPage(
          updateFastingDays: (days) {
            setState(() {
              fastingDays = days;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // (Seluruh isi Widget build tetap sama, tidak ada perubahan di sini)
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Hi, ${widget.userName}'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _navigateToProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPrayerTimesHeader(),
            const SizedBox(height: 16),
            _buildPrayerGrid(),
            const SizedBox(height: 16),
            _buildMenuButtons(),
            const SizedBox(height: 16),
            _buildDailyVerseCard(),
          ],
        ),
      ),
    );
  }

  // (Fungsi _buildPrayerTimesHeader tetap sama)
  Widget _buildPrayerTimesHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _isLoading
          ? const Center(
              child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white),
            ))
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: prayerTimes.entries
                  .map(
                    (entry) => Column(
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          entry.value,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
    );
  }

  // (Fungsi _buildPrayerGrid tetap sama)
  Widget _buildPrayerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: prayerStatus.length,
      itemBuilder: (context, index) {
        String prayerName = prayerStatus.keys.elementAt(index);
        bool isDone = prayerStatus[prayerName]!['status'];
        String note = prayerStatus[prayerName]!['note'];

        return GestureDetector(
          onTap: () => _showPrayerDialog(prayerName),
          child: Card(
            elevation: 2,
            color: isDone ? const Color(0xFF2E7D32) : Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isDone ? Colors.white : Colors.grey[400],
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(
                  prayerName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDone ? Colors.white : Colors.black,
                  ),
                ),
                if (note.isNotEmpty)
                  Icon(
                    Icons.note_alt,
                    size: 12,
                    color: isDone ? Colors.white70 : Colors.grey,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // (Fungsi _buildMenuButtons tetap sama)
  Widget _buildMenuButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMenuButton(Icons.book, 'Al-Quran', _navigateToQuran),
        _buildMenuButton(Icons.calendar_month, 'Puasa', _navigateToPuasa),
      ],
    );
  }

  // (Fungsi _buildMenuButton tetap sama)
  Widget _buildMenuButton(IconData icon, String label, VoidCallback onPressed) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Icon(icon, size: 30, color: const Color(0xFF2E7D32)),
                const SizedBox(height: 8),
                Text(label,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // (Fungsi _buildDailyVerseCard tetap sama)
  Widget _buildDailyVerseCard() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _dailyVerse,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final verse = snapshot.data ??
            {
              'text': 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang',
              'surah': 'Al-Fatihah',
              'number': 1,
            };

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Column(
            children: [
              const Icon(Icons.lightbulb, color: Colors.green, size: 30),
              const SizedBox(height: 8),
              Text(
                '\"${verse['text']}\"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'QS. ${verse['surah']}:${verse['number']}',
                style: const TextStyle(fontSize: 12, color: Colors.green),
              ),
            ],
          ),
        );
      },
    );
  }
}
