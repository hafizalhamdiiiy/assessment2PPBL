import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _drivers = [];
  String _sortField = 'nama';
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _loadDrivers();
    _loadSortPreferences();
  }

  Future<void> _loadDrivers() async {
    final database = await DatabaseHelper.instance.database;
    final drivers = await database.query('tukangojek');
    setState(() {
      _drivers = drivers;
      _sortDrivers();
    });
  }

  Future<void> _loadSortPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sortField = prefs.getString('sortField') ?? 'nama';
      _sortAscending = prefs.getBool('sortAscending') ?? true;
    });
  }

  Future<void> _saveSortPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sortField', _sortField);
    prefs.setBool('sortAscending', _sortAscending);
  }

  void _sortDrivers() {
    _drivers.sort((a, b) {
      if (_sortAscending) {
        return a[_sortField].toString().compareTo(b[_sortField].toString());
      } else {
        return b[_sortField].toString().compareTo(a[_sortField].toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OPANGATIMIN'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          const Text(
            'List Tukang Ojek',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.sort_by_alpha),
                onPressed: () {
                  setState(() {
                    _sortField = 'nama';
                    _sortAscending = !_sortAscending;
                    _sortDrivers();
                    _saveSortPreferences();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.sort),
                onPressed: () {
                  setState(() {
                    _sortField = 'jumlah_order';
                    _sortAscending = !_sortAscending;
                    _sortDrivers();
                    _saveSortPreferences();
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _drivers.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListTile(
                    title: Text(_drivers[index]['nama']),
                    subtitle: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jumlah Order: 5'),
                        Text('Omzet: Rp. 100000'),
                      ],
                    ),
                    onTap: () {
                      // Navigasi atau tindakan lain saat item di-tap
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/addDriver');
                },
                child: Text('Tambah Tukang Ojek'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/addTransaction');
                },
                child: Text('Tambah Transaksi'),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
