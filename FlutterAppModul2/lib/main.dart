import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// Root widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Row and Column',
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App'),
          backgroundColor: Colors.amber[700],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KotakIkon(
                    warnaKotak: Colors.blue,
                    icon: Icons.favorite,
                    warnaIcon: Colors.red,
                    label: "Suka",
                  ),
                  SizedBox(width: 10),
                  KotakIkon(
                    warnaKotak: Colors.green,
                    icon: Icons.thumb_up,
                    warnaIcon: const Color.fromARGB(255, 229, 254, 2),
                    label: "Cinta",
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KotakIkon(
                    warnaKotak: Colors.purple,
                    icon: Icons.star,
                    warnaIcon: const Color.fromARGB(255, 249, 249, 249),
                    label: "Like",
                  ),
                  SizedBox(width: 10),
                  KotakIkon(
                    warnaKotak: Colors.orange,
                    icon: Icons.trip_origin,
                    warnaIcon: const Color.fromARGB(255, 86, 54, 244),
                    label: "Love",
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Aksi saat tombol ditekan (opsional)
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.amber[700],
        ),
      ),
    );
  }
}

// Widget kustom kotak dengan ikon dan teks
class KotakIkon extends StatelessWidget {
  final Color warnaKotak;
  final IconData icon;
  final Color warnaIcon;
  final String label;

  const KotakIkon({
    Key? key,
    required this.warnaKotak,
    required this.icon,
    required this.warnaIcon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: warnaKotak,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Icon(icon, color: warnaIcon, size: 40),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
