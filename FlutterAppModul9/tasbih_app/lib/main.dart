import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
// Pastikan package SimpleCircularProgressBar sudah di-import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const TasbihApp();
  }
}

class TasbihApp extends StatefulWidget {
  const TasbihApp({super.key});

  @override
  State<TasbihApp> createState() => _TasbihAppState();
}

class _TasbihAppState extends State<TasbihApp> {
  // State untuk menyimpan hitungan dzikir/tasbih
  double counter = 0;

  // State untuk SimpleCircularProgressBar
  late ValueNotifier<double> _valueNotifier;

  // Nilai Maksimum Dzikir dalam satu siklus (misalnya 33 untuk Subhanallah)
  final int maxDzikirCycle = 33;

  // Nilai Maksimum untuk Progress Bar
  final double maxProgressValue = 100.0;

  @override
  void initState() {
    super.initState();
    // Inisialisasi ValueNotifier dengan nilai awal 0
    _valueNotifier = ValueNotifier(0.0);
  }

  // Method untuk menambah hitungan
  void incrementCounter() {
    setState(() {
      counter++;

      // Hitungan untuk Progress Bar: (Counter % 33) / 33 * 100
      // Ini menghitung progres dalam satu siklus (0 hingga 33) dan menampilkannya sebagai 0-100%
      double currentCycleCount = counter % maxDzikirCycle;
      _valueNotifier.value =
          (currentCycleCount / maxDzikirCycle) * maxProgressValue;

      // Jika counter mencapai kelipatan 33, pastikan progres bar mencapai 100
      if (currentCycleCount == 0 && counter > 0) {
        _valueNotifier.value = maxProgressValue;
      }
    });
  }

  // Method untuk mereset hitungan
  void resetCounter() {
    setState(() {
      counter = 0;
      _valueNotifier.value = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mengatur status bar menjadi transparan
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 119, 210, 145),
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 210, 119, 125),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Menampilkan total hitungan (di atas progress bar)
                Text(
                  // Menampilkan jumlah siklus (total / 33)
                  'Total Siklus: ${(counter / maxDzikirCycle).floor()}',
                  style: const TextStyle(fontSize: 20, color: Colors.white70),
                ),
                const SizedBox(height: 10),
                SimpleCircularProgressBar(
                  progressColors: [Colors.amberAccent.shade400],
                  size: 300,
                  progressStrokeWidth: 20,
                  backStrokeWidth: 10,
                  mergeMode: true,
                  // Menggunakan nilai 100 sebagai maksimum progress bar
                  maxValue: maxProgressValue,
                  animationDuration: 0,
                  valueNotifier: _valueNotifier,
                  onGetText: (value) {
                    // Menampilkan hitungan saat ini dalam siklus (0 hingga 32)
                    return Text(
                      '${(counter.toInt() % maxDzikirCycle) == 0 && counter > 0 ? maxDzikirCycle : (counter.toInt() % maxDzikirCycle)}',
                      style: const TextStyle(
                        fontSize: 170,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: InkWell(
                    onTap: incrementCounter,
                    child: Container(
                      width: 150, // Memberi ukuran tetap untuk tombol
                      height: 150,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 8),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.fingerprint,
                        color: Color.fromARGB(255, 119, 210, 145),
                        size: 100,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Floating Action Button untuk reset
        floatingActionButton: FloatingActionButton(
          onPressed: resetCounter,
          backgroundColor: Colors.white,
          foregroundColor: const Color.fromARGB(255, 119, 210, 145),
          child: const Icon(Icons.refresh_outlined),
        ),
      ),
    );
  }
}
