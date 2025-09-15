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
      title: 'Demo ListView',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            listTile(
              Colors.blueAccent.shade400,
              Colors.greenAccent.shade400,
              'Kehadiran',
              'Presensi Kehadiran Kuliah',
              'assets/icon/boy.png',
            ),
            listTile(
              Colors.greenAccent.shade400,
              Colors.blueAccent.shade400,
              'Jadwal',
              'Jadwal  Perkuliahan',
              'assets/icon/timetable.png',
            ),
            listTile(
              Colors.yellowAccent.shade400,
              Colors.blueAccent.shade400,
              'Tugas',
              'Tugas Perkuliahan di Luar Kelas',
              'assets/icon/homeschooling.png',
            ),
            listTile(
              Colors.redAccent.shade400,
              Colors.amberAccent.shade400,
              'Pengumuman',
              'Informasi terkait Perkuliahan',
              'assets/icon/clipboard.png',
            ),
            listTile(
              Colors.purpleAccent.shade400,
              Colors.tealAccent.shade400,
              'Nilai',
              'Nilai Ujian dan Tugas',
              'assets/icon/marks.png',
            ),
            listTile(
              Colors.tealAccent.shade400,
              Colors.purpleAccent.shade400,
              'Catatan',
              'Pengingat Kegiatan Perkuliahan',
              'assets/icon/pencil.png',
            ),
          ],
        ),
      ),
    );
  }
}

Container listTile(
  Color warna,
  Color warnaAvatar,
  String judul,
  String subjudul,
  String gambar,
) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: ListTile(
      tileColor: warna,
      title: Text(
        judul,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subjudul, style: const TextStyle(fontSize: 16)),
      leading: CircleAvatar(
        backgroundColor: warnaAvatar,
        child: Image.asset(gambar, width: 35, height: 35),
      ),
      trailing: Icon(Icons.star, color: Colors.orangeAccent.shade400),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
