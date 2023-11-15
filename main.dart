import 'package:flutter/material.dart';
import 'package:opangatimin/home_page.dart';
import 'package:opangatimin/tambah_driver.dart';
import 'package:opangatimin/tambah_transaksi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi OPANGATIMIN App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/addDriver': (context) => AddDriverPage(),
        '/addTransaction': (context) => AddTransactionPage(),
      },
    );
  }
}
