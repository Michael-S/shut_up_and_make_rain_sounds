import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/services.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shut Up And Make Rain Sounds',
      theme: ThemeData(
        // This is the theme of your application.

        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Shut Up And Make Rain Sounds'),
    );
  }
}

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String aboutContents = "whatever";

  //Future<void> _loadData() async {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final _loadedData = await rootBundle.loadString(
          'assets/text/about_and_license.txt');
      setState(() {
        aboutContents = _loadedData;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Page'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ElevatedButton(
                child: const Text('Back To Main', style: TextStyle(color: Colors.black, fontSize: 28.0)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp())
                  ); }
            ),
            Text(aboutContents, style: const TextStyle(color: Colors.black, fontSize: 16.0)),
          ],
        ),
      ),
    );
  }


}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
  bool _playingRainSounds = false;
  AudioPlayer player = AudioPlayer();
  String audioasset = "assets/audio/rain_and_thunder_public_domain.mp3";

  void _togglePlayingRainSounds() {
    setState(() {
      _playingRainSounds = !_playingRainSounds;
      if (_playingRainSounds) {
        Future.delayed(Duration.zero, () async {
          player.setReleaseMode(ReleaseMode.LOOP);
          if (!kIsWeb && Platform.isAndroid) {
            // For some reason, I can't get Android to play the asset locally.
            // I am getting IOExceptions loading the file from the URL with player.play(audioasset, isLocal: true);
            ByteData bytes = await rootBundle.load(audioasset); //load audio from assets
            Uint8List audiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
            player.playBytes(audiobytes);
          } else {
            player.play(audioasset, isLocal: true);
          }
        });
      } else {
        Future.delayed(Duration.zero, () async {
          await player.stop();
        });
      }
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
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                child: const Text('About', style: TextStyle(color: Colors.black, fontSize: 28.0)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage())
                  ); }
            ),
           TextButton(
              style: ButtonStyle(
                backgroundColor: _playingRainSounds ? MaterialStateProperty.all<Color>(Colors.red) : MaterialStateProperty.all<Color>(Colors.green),
                textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 28.0)),
              ) ,
              child: _playingRainSounds ? const Text("Stop Rain Sounds", style: TextStyle(color: Colors.black))
                  : const Text("Start Rain Sounds", style: TextStyle(color: Colors.black)),
              onPressed: _togglePlayingRainSounds,
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
