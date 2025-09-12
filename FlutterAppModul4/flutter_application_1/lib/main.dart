import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Malang', style: TextStyle(fontSize: 30)),
            Text(
              '25°C',
              style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
            ),
            Text('Cerah Berawan', style: TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                harian('Sen', '27°C', Icons.wb_sunny),
                harian('Sel', '26°C', Icons.cloud),
                harian('Rab', '24°C', Icons.beach_access),
                harian('Kam', '25°C', Icons.wb_cloudy),
                harian('Jum', '27°C', Icons.wb_sunny),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Container harian(String hari, String suhu, IconData icon) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(hari, style: TextStyle(fontSize: 18)),
        Icon(icon),
        Text(suhu, style: TextStyle(fontSize: 18)),
      ],
    ),
  );
}
