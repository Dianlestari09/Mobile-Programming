// quran_page.dart (PERBAIKAN FINAL - Hapus Transliterasi Ayat)

import 'package:flutter/material.dart';
import 'api_service.dart';

// HALAMAN UTAMA (DAFTAR SURAH)
// (Bagian ini sudah benar, menampilkan Arab di kanan dan Transliterasi di kiri)
class QuranPage extends StatefulWidget {
  final Function(int) onSurahRead;

  const QuranPage({super.key, required this.onSurahRead});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  List<dynamic> _surahs = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final surahs = await QuranApiService.getSurahList();
      setState(() {
        _surahs = surahs;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat daftar surah. Periksa koneksi internet.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<dynamic> get _filteredSurahs {
    if (_searchQuery.isEmpty) {
      return _surahs;
    }
    return _surahs.where((surah) {
      final transliteration =
          surah['name']?['transliteration']?['id']?.toString().toLowerCase() ??
              '';
      final translation =
          surah['name']?['translation']?['id']?.toString().toLowerCase() ?? '';
      final arabicName =
          surah['name']?['short']?.toString().toLowerCase() ?? '';

      final query = _searchQuery.toLowerCase();

      return transliteration.contains(query) ||
          translation.contains(query) ||
          arabicName.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Quran'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari surah (misal: Al-Fatihah)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }
    if (_filteredSurahs.isEmpty) {
      return const Center(
          child: Text('Surah tidak ditemukan.',
              style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      itemCount: _filteredSurahs.length,
      itemBuilder: (context, index) {
        final surah = _filteredSurahs[index];
        final surahNumber = surah['number'];
        final surahArabicName = surah['name']?['short']?.toString() ?? '...';
        final surahTransliteration =
            surah['name']?['transliteration']?['id']?.toString() ?? 'Unknown';
        final verseCount = surah['numberOfVerses'];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              child: Text(surahNumber.toString()),
            ),
            title: Text(
              surahArabicName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            subtitle: Text('$surahTransliteration | $verseCount Ayat'),
            onTap: () {
              widget.onSurahRead(surahNumber);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _QuranDetailPage(surah: surah),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// HALAMAN DETAIL (DAFTAR AYAT)
// --- SEMUA PERBAIKAN ADA DI BAGIAN BAWAH INI ---
class _QuranDetailPage extends StatefulWidget {
  final dynamic surah;
  const _QuranDetailPage({required this.surah});

  @override
  State<_QuranDetailPage> createState() => _QuranDetailPageState();
}

class _QuranDetailPageState extends State<_QuranDetailPage> {
  Map<String, dynamic>? _surahDetail;
  bool _isLoadingDetail = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSurahDetail();
  }

  Future<void> _loadSurahDetail() async {
    setState(() {
      _isLoadingDetail = true;
      _errorMessage = '';
    });
    try {
      // Panggilan API (sudah benar)
      final detail =
          await QuranApiService.getSurahDetail(widget.surah['number']);
      setState(() {
        _surahDetail = detail;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat detail surah: $e';
      });
    } finally {
      setState(() {
        _isLoadingDetail = false;
      });
    }
  }

  // --- PERBAIKAN 1: Dialog Share (Transliterasi dihapus) ---
  void _showShareDialog(Map<String, dynamic> verse) {
    // Logika baru untuk mengambil data (berlaku untuk dummy & API asli)
    final dynamic numberData = verse['number'];
    final String number = (numberData is Map)
        ? numberData['inSurah'].toString()
        : numberData.toString();

    final dynamic arabicData = verse['text'];
    final String arabicText = (arabicData is Map)
        ? arabicData['arab']?.toString() ?? '...'
        : arabicData?.toString() ?? '...';

    final dynamic translationData = verse['translation'];
    final String translation = (translationData is Map)
        ? translationData['id']?.toString() ?? '...'
        : translationData?.toString() ?? '...';

    final arabicSurahName = widget.surah['name']?['short']?.toString() ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bagikan Ayat'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hanya Nama Arab + Nomor Ayat
              Text(
                '$arabicSurahName Ayat $number',
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 12),
              // Teks Arab
              Text(
                arabicText,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 12),
              // Terjemahan
              Text(
                translation,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
  // --- BATAS PERBAIKAN 1 ---

  @override
  Widget build(BuildContext context) {
    // --- PERBAIKAN 2: Judul AppBar (Menggunakan Transliterasi) ---
    // Sesuai daftar list, AppBar pakai "Al-Fatihah", bukan "Pembukaan"
    final String surahName =
        widget.surah['name']?['transliteration']?['id']?.toString() ?? 'Detail';
    // --- BATAS PERBAIKAN 2 ---

    return Scaffold(
      appBar: AppBar(
        title: Text(surahName), // Judul AppBar "Al-Fatihah"
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: _buildDetailContent(),
    );
  }

  // --- PERBAIKAN 3: Isi Halaman Detail (Transliterasi Dihapus) ---
  Widget _buildDetailContent() {
    if (_isLoadingDetail) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }
    if (_surahDetail == null || (_surahDetail!['verses'] as List).isEmpty) {
      return const Center(child: Text('Tidak ada data ayat.'));
    }

    final verses = _surahDetail!['verses'] as List;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: verses.length,
      itemBuilder: (context, index) {
        final verse = verses[index];

        // --- LOGIKA BARU UNTUK MENGAMBIL DATA ---
        // (Ini penting agar Surah 1 dan Surah 2 dst bisa tampil)

        // 1. Ambil Nomor Ayat
        final dynamic numberData = verse['number'];
        final String number = (numberData is Map)
            ? numberData['inSurah'].toString() // Dari API Asli
            : numberData.toString(); // Dari Dummy Data

        // 2. Ambil Teks Arab
        final dynamic arabicData = verse['text'];
        final String arabicText = (arabicData is Map)
            ? arabicData['arab']?.toString() ?? '...' // Dari API Asli
            : arabicData?.toString() ?? '...'; // Dari Dummy Data

        // 3. Ambil Terjemahan
        final dynamic translationData = verse['translation'];
        final String translation = (translationData is Map)
            ? translationData['id']?.toString() ?? '...' // Dari API Asli
            : translationData?.toString() ?? '...'; // Dari Dummy Data

        // (Transliterasi ayat tidak kita ambil)
        // --- BATAS LOGIKA BARU ---

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.green[100],
                      child: Text(
                        number, // Gunakan nomor yang sudah diproses
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF2E7D32)),
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.share, color: Colors.grey, size: 20),
                      onPressed: () => _showShareDialog(verse),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // HANYA TAMPILKAN TEKS ARAB
                Text(
                  arabicText, // Gunakan teks Arab yang sudah diproses
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 12),

                // HANYA TAMPILKAN TERJEMAHAN
                Text(
                  translation, // Gunakan terjemahan yang sudah diproses
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                  ),
                ),

                // (BAGIAN TRANSLITERASI AYAT SUDAH DIHAPUS)
              ],
            ),
          ),
        );
      },
    );
  }
  // --- BATAS PERBAIKAN 3 ---
}
