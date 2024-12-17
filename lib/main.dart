import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ESP32 CAM',
      theme: ThemeData.dark(),
      home: Home(
        channel: IOWebSocketChannel.connect('ws://192.168.1.70:8888'),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, required this.channel});

  final WebSocketChannel channel;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ESP32"),
      ),
      body: Container(
        color: Colors.black,
        child: StreamBuilder(
          stream: widget.channel.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else {
              return Image.memory(
                snapshot.data,
                gaplessPlayback: true,
              );
            }
          },
        ),
      ),
    );
  }
}
