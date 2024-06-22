import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soverin',
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isListening = false;
  int port = 0;

  @override
  void initState() {
    super.initState();
    _initServer();
  }

  _initServer() async {
    final s = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    s.listen(_handleReq);

    setState(() {
      isListening = true;
      port = s.port;
    });
  }

  _handleReq(HttpRequest request) async {
    try {
      request.response.headers.add('Content-Type', 'text/html; charset=utf-8');
      request.response.add(utf8.encode('test').buffer.asUint8List());
      request.response.close();
    } catch (err) {
      request.response.statusCode = 404;
      request.response.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isListening
            ? Text(
                'Listening on ip: ${InternetAddress.loopbackIPv4.address} port: $port...')
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
