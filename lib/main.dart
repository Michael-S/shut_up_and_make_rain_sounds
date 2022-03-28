import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
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
      final _loadedData =
          await rootBundle.loadString('assets/text/about_and_license.txt');
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
            Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  child: const Text('Back', style: TextStyle(fontSize: 28.0)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const MyApp()));
                  }),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Linkify(
                onOpen: (link) async {
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                options: const LinkifyOptions(humanize: false),
                text: aboutContents,
                style: const TextStyle(color: Colors.black, fontSize: 14.0),
                linkStyle: const TextStyle(
                    color: Colors.blue,
                    fontSize: 14.0,
                    decoration: TextDecoration.underline),
              ),
            ),
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
  int _playingIndex = 0;
  AudioPlayer player = AudioPlayer();
  List<String> audioAssets = [
    "assets/audio/rain_and_thunder_public_domain_1.mp3",
    "assets/audio/rain_and_thunder_public_domain_2.mp3",
    "assets/audio/rain_and_thunder_public_domain_3.mp3",
  ];
  double _buttonPadding = 25.0;

  Future playSound(int index) async {
    player.setReleaseMode(ReleaseMode.LOOP);
    if (!kIsWeb && Platform.isAndroid) {
      // For some reason, I can't get Android to play the asset locally.
      // I am getting IOExceptions loading the file from the URL with player.play(audioasset, isLocal: true);
      ByteData bytes =
          await rootBundle.load(audioAssets[index]); //load audio from assets
      Uint8List audiobytes =
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      return player.playBytes(audiobytes);
    } else {
      return player.play(audioAssets[index], isLocal: true);
    }
  }

  void _togglePlayingRainSounds(int index) {
    setState(() {
      if (_playingRainSounds && _playingIndex == index) {
        // stop the current track
        Future.delayed(Duration.zero, () async {
          await player.stop();
        });
        _playingRainSounds = false;
      } else if (_playingRainSounds) {
        // switch track
        Future.delayed(Duration.zero, () async {
          await player.stop().then((ignored) => playSound(index));
        });
        // _playingRainSounds stays true
      } else {
        Future.delayed(Duration.zero, () async {
          await playSound(index);
        });
        _playingRainSounds = true;
      }
      _playingIndex = index;
    });
  }

  void _togglePlayingRainSounds1() {
    _togglePlayingRainSounds(0);
  }

  void _togglePlayingRainSounds2() {
    _togglePlayingRainSounds(1);
  }

  void _togglePlayingRainSounds3() {
    _togglePlayingRainSounds(2);
  }

  bool playingRainSoundsAtIndex(int index) {
    return _playingRainSounds && _playingIndex == index;
  }

  String rainSoundsButtonText(int index) {
    if (_playingRainSounds && _playingIndex == index) {
      return "Stop All Rain Sounds";
    } else if (_playingRainSounds) {
      return "Switch To Rain Sound " + (index + 1).toString();
    } else {
      return "Start Rain Sound " + (index + 1).toString();
    }
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
            Container(
                padding: EdgeInsets.all(_buttonPadding),
                child: ElevatedButton(
                    child:
                        const Text('About', style: TextStyle(fontSize: 28.0)),
                    onPressed: () {
                      if (_playingRainSounds) {
                        _togglePlayingRainSounds(_playingIndex);
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AboutPage()));
                    })),
            Container(
              padding: EdgeInsets.all(_buttonPadding),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: playingRainSoundsAtIndex(0)
                      ? MaterialStateProperty.all<Color>(Colors.red)
                      : MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: Text(rainSoundsButtonText(0),
                    style:
                        const TextStyle(color: Colors.white, fontSize: 28.0)),
                onPressed: _togglePlayingRainSounds1,
              ),
            ),
            Container(
              padding: EdgeInsets.all(_buttonPadding),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: playingRainSoundsAtIndex(1)
                      ? MaterialStateProperty.all<Color>(Colors.red)
                      : MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: Text(rainSoundsButtonText(1),
                    style:
                        const TextStyle(color: Colors.white, fontSize: 28.0)),
                onPressed: _togglePlayingRainSounds2,
              ),
            ),
            Container(
              padding: EdgeInsets.all(_buttonPadding),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: playingRainSoundsAtIndex(2)
                      ? MaterialStateProperty.all<Color>(Colors.red)
                      : MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: Text(rainSoundsButtonText(2),
                    style:
                        const TextStyle(color: Colors.white, fontSize: 28.0)),
                onPressed: _togglePlayingRainSounds3,
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
