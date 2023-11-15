import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';

class AddDriverPage extends StatefulWidget {
  @override
  _AddDriverPageState createState() => _AddDriverPageState();
}

class _AddDriverPageState extends State<AddDriverPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nopolController = TextEditingController();

  Future<void> _saveDriver() async {
    if (_namaController.text.isEmpty || _nopolController.text.isEmpty) {
      return;
    }

    final database = await DatabaseHelper.instance.database;
    await database.insert(
      'tukangojek',
      {
        'nama': _namaController.text,
        'nopol': _nopolController.text,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Tukang Ojek'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _nopolController,
              decoration: InputDecoration(labelText: 'Nomor Polisi'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _saveDriver();
                  Navigator.pop(context);
                } catch (e) {
                  print('Error: $e');
                }
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
