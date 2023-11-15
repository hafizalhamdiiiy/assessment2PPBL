import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';

class AddTransactionPage extends StatefulWidget {
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final TextEditingController _hargaController = TextEditingController();
  int _selectedDriverId = 0;

  List<Map<String, dynamic>> _drivers = [];

  @override
  void initState() {
    super.initState();
    _loadDrivers();
  }

  Future<void> _loadDrivers() async {
    final database = await DatabaseHelper.instance.database;
    final drivers = await database.query('tukangojek');
    setState(() {
      _drivers = drivers;
    });
  }

  Future<void> _saveTransaction() async {
    if (_selectedDriverId == 0 || _hargaController.text.isEmpty) {
      return;
    }

    final database = await DatabaseHelper.instance.database;
    await database.insert(
      'transaksi',
      {
        'tukangojek_id': _selectedDriverId,
        'harga': int.parse(_hargaController.text),
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<int>(
              value: _selectedDriverId,
              onChanged: (newValue) {
                setState(() {
                  _selectedDriverId = newValue!;
                });
              },
              items: _drivers.map((driver) {
                return DropdownMenuItem<int>(
                  value: driver['id'],
                  child: Text(driver['nama']),
                );
              }).toList(),
              hint: Text('Pilih Tukang Ojek'),
            ),
            TextField(
              controller: _hargaController,
              decoration: InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _saveTransaction();
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
