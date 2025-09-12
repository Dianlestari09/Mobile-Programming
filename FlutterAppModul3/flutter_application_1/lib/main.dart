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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[const Text('Pemutar Musik')],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: Colors.black54,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: const Icon(Icons.shuffle, color: Colors.white, size: 30),
            ),

            Expanded(
              child: const Icon(
                Icons.skip_previous,
                color: Colors.white,
                size: 30,
              ),
            ),

            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 60,
              ),
            ),

            Expanded(
              child: const Icon(Icons.skip_next, color: Colors.white, size: 30),
            ),

            Expanded(
              child: const Icon(Icons.repeat, color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
