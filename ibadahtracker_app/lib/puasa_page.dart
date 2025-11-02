import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PuasaPage extends StatefulWidget {
  final Function(int) updateFastingDays;

  const PuasaPage({super.key, required this.updateFastingDays});

  @override
  State<PuasaPage> createState() => _PuasaPageState();
}

class _PuasaPageState extends State<PuasaPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  late Set<DateTime> _fastingDays;

  // Definisikan firstDay dan lastDay dengan range yang aman
  final DateTime _firstDay = DateTime(2023, 1, 1);
  final DateTime _lastDay = DateTime(2025, 12, 31);

  @override
  void initState() {
    super.initState();
    // Pastikan focusedDay berada dalam range firstDay dan lastDay
    final now = DateTime.now();
    _focusedDay =
        now.isBefore(_lastDay) && now.isAfter(_firstDay) ? now : _firstDay;
    _selectedDay = _focusedDay;
    _fastingDays = {};
  }

  // ... (Fungsi _onDaySelected dan _toggleFastingDay tetap sama) ...
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  void _toggleFastingDay() {
    if (_selectedDay == null) return;
    setState(() {
      final selectedDate = DateTime.utc(
          _selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
      if (_fastingDays.contains(selectedDate)) {
        _fastingDays.remove(selectedDate);
      } else {
        _fastingDays.add(selectedDate);
      }
      widget.updateFastingDays(_fastingDays.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender Puasa'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      // --- PERUBAHAN DIMULAI DI SINI ---
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // <--- WIDGET DITAMBAHKAN
          child: Column(
            // <--- Column ini sekarang ada di dalam SingleChildScrollView
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Kalender
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    firstDay: _firstDay,
                    lastDay: _lastDay,
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    eventLoader: (day) =>
                        _fastingDays.contains(day) ? ['Puasa'] : [],
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.green[200],
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    onDaySelected: _onDaySelected,
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Tombol
              ElevatedButton.icon(
                onPressed: _toggleFastingDay,
                icon: const Icon(Icons.add),
                label: const Text('Tandai Puasa Hari Ini'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Info Puasa
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Info Puasa Sunnah',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _buildFastingInfo(
                        'Senin & Kamis',
                        'Puasa sunah yang dianjurkan',
                      ),
                      _buildFastingInfo(
                          '13,14,15 Hijriah', 'Puasa Ayyamul Bidh'),
                      _buildFastingInfo('9 & 10 Muharram', 'Puasa Asyura'),
                      _buildFastingInfo(
                          'Ramadhan', 'Puasa wajib sebulan penuh'),
                      _buildFastingInfo(
                          'Syawal', 'Puasa 6 hari di bulan Syawal'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ), // <--- PENUTUP SingleChildScrollView
      ),
      // --- PERUBAHAN SELESAI DI SINI ---
    );
  }

  Widget _buildFastingInfo(String day, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 8),
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
