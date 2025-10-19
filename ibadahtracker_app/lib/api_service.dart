import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api.aladhan.com/v1';

  static Future<Map<String, String>> getPrayerTimes() async {
    try {
      // Menggunakan Jakarta sebagai lokasi default
      final response = await http.get(Uri.parse(
          '$_baseUrl/timingsByAddress?address=Jakarta,Indonesia&method=2'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];

        // Memetakan nama sholat dari API ke nama yang kita inginkan
        return {
          'Shubuh': _formatTime(timings['Fajr']),
          'Dzuhur': _formatTime(timings['Dhuhr']),
          'Ashar': _formatTime(timings['Asr']),
          'Maghrib': _formatTime(timings['Maghrib']),
          'Isya': _formatTime(timings['Isha']),
        };
      } else {
        // Jika API gagal, lempar exception
        throw Exception('Failed to load prayer times: ${response.statusCode}');
      }
    } catch (e) {
      // Jika terjadi error (misal tidak ada internet),
      // kembalikan data dummy/fallback
      print('Error fetching prayer times: $e');
      return {
        'Shubuh': '04:30',
        'Dzuhur': '12:00',
        'Ashar': '15:30',
        'Maghrib': '18:00',
        'Isya': '19:20',
      };
    }
  }

  // Fungsi helper untuk format waktu (mengambil HH:MM)
  static String _formatTime(String time) {
    return time.substring(0, 5);
  }
}

class QuranApiService {
  static const String _quranBaseUrl = 'https://api.quran.gading.dev';

  // Mengambil daftar semua surah
  static Future<List<dynamic>> getSurahList() async {
    try {
      final response = await http.get(Uri.parse('$_quranBaseUrl/surah'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load surah list');
      }
    } catch (e) {
      print('Error fetching surah list: $e');
      return []; // Kembalikan list kosong jika error
    }
  }

  // Mengambil detail surah (termasuk ayat)
  static Future<Map<String, dynamic>> getSurahDetail(int surahNumber) async {
    // Gunakan data dummy jika nomor surah adalah 1 (Al-Fatihah)
    // Sesuai dengan spesifikasi awal (menggunakan data dummy)
    if (surahNumber == 1) {
      // Simulasi network delay agar terasa seperti memuat data
      await Future.delayed(const Duration(milliseconds: 300));
      return _juz1Data;
    }

    // Jika surah selain 1, coba panggil API
    try {
      final response =
          await http.get(Uri.parse('$_quranBaseUrl/surah/$surahNumber'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load surah detail');
      }
    } catch (e) {
      print('Error fetching surah detail: $e');
      // Jika API gagal, kembalikan data error atau data dummy
      // Di sini kita kembalikan Al-Fatihah sebagai fallback
      return _juz1Data;
    }
  }

  // --- FUNGSI BARU YANG DITAMBAHKAN ---
  // Mengambil "ayat harian" untuk ditampilkan di main menu
  static Future<Map<String, dynamic>> getDailyVerse() async {
    // Simulasi pengambilan ayat harian.
    // Kita akan ambil ayat pertama (Basmalah) dari data dummy Juz 1
    // agar sesuai dengan apa yang diharapkan oleh main_menu.dart
    await Future.delayed(const Duration(milliseconds: 500)); // Simulasi network delay
    
    try {
      // Ambil data dari _juz1Data yang sudah ada di file ini
      final surahName = _juz1Data['name'] as String;
      final verseData = (_juz1Data['verses'] as List).first as Map<String, dynamic>;
      
      return {
        // Kita gunakan 'translation' untuk field 'text' agar sesuai
        // dengan fallback data di main_menu.dart
        'text': verseData['translation'], 
        'surah': surahName,
        'number': verseData['number'],
      };
    } catch (e) {
      // Fallback jika data dummy gagal diproses
      return {
        'text': 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
        'surah': 'Al-Fatihah',
        'number': 1,
      };
    }
  }
  // --- BATAS FUNGSI BARU ---


  // Data dummy (Juz 1 / Al-Fatihah)
  // Sesuai spesifikasi II.b
  static final Map<String, dynamic> _juz1Data = {
    'number': 1,
    'name': 'Al-Fatihah',
    'englishName': 'The Opening',
    'numberOfVerses': 7,
    'verses': [
      {
        'text': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        'translation': 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
        'number': 1
      },
      {
        'text': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        'translation': 'Segala puji bagi Allah, Tuhan seluruh alam,',
        'number': 2
      },
      {
        'text': 'الرَّحْمَٰنِ الرَّحِيمِ',
        'translation': 'Yang Maha Pengasih, Maha Penyayang,',
        'number': 3
      },
      {
        'text': 'مَالِكِ يَوْمِ الدِّينِ',
        'translation': 'Pemilik hari pembalasan.',
        'number': 4
      },
      {
        'text': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
        'translation':
            'Hanya kepada Engkaulah kami menyembah dan hanya kepada Engkaulah kami mohon pertolongan.',
        'number': 5
      },
      {
        'text': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
        'translation': 'Tunjukilah kami jalan yang lurus,',
        'number': 6
      },
      {
        'text':
            'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
        'translation':
            '(yaitu) jalan orang-orang yang telah Engkau beri nikmat kepadanya; bukan (jalan) mereka yang dimurkai, dan bukan (pula jalan) mereka yang sesat.'
      }
    ]
  };
}