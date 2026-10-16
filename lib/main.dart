import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check Internet Connection',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Check Internet Connection'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Variabel untuk menyimpan status koneksi internet
  late bool isConnected;

  // Objek untuk memeriksa koneksi internet
  final Connectivity _connectivity = Connectivity();

  // Langganan untuk mendengarkan perubahan koneksi
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    // Set nilai awal status koneksi sebagai true (terhubung)
    isConnected = true;

    // Memanggil fungsi pengecekan koneksi internet dan mendengarkan perubahan koneksi setelah selesai
    _initConnectionStatus().then((_) {
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
        result,
      ) {
        setState(() {
          isConnected = !result.contains(ConnectivityResult.none);
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    // Batalkan langganan saat widget dihancurkan untuk menghindari kebocoran memori
    _connectivitySubscription.cancel();
  }

  // Fungsi untuk memeriksa status koneksi internet saat pertama kali aplikasi dijalankan
  Future<void> _initConnectionStatus() async {
    final result = await _connectivity.checkConnectivity();
    setState(() {
      // Perbarui status koneksi berdasarkan hasil pengecekan
      isConnected = !result.contains(ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          child: Image.asset(
            isConnected ? 'assets/connected.png' : 'assets/disconnected.png',
            key: ValueKey<bool>(isConnected),
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
