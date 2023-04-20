import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Provider>> _fetchProviders() async {
  final response =
      await http.get(Uri.parse('http://2.58.242.222:8080/provider/get-all/'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
    return jsonList.map((json) => Provider.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load providers');
  }
}

class Provider {
  final int id;
  final String name;
  final String address;
  final String contactPerson;
  final String phoneNumber;

  Provider({
    required this.id,
    required this.name,
    required this.address,
    required this.contactPerson,
    required this.phoneNumber,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      contactPerson: json['contact_person'],
      phoneNumber: json['phone_number'],
    );
  }
}

class MyDataTable extends StatefulWidget {
  MyDataTable({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyDataTableState createState() => _MyDataTableState();
}

class _MyDataTableState extends State<MyDataTable> {
  late Future<List<Provider>> _providers;

  @override
  void initState() {
    super.initState();
    _providers = _fetchProviders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Provider>>(
        future: _providers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Provider> providers = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Name'),
                    ),
                    DataColumn(
                      label: Text('Address'),
                    ),
                    DataColumn(
                      label: Text('Contact Person'),
                    ),
                    DataColumn(
                      label: Text('Phone Number'),
                    ),
                  ],
                  rows: providers
                      .map((provider) => DataRow(cells: <DataCell>[
                            DataCell(Text(provider.name)),
                            DataCell(Text(provider.address)),
                            DataCell(Text(provider.contactPerson)),
                            DataCell(Text(provider.phoneNumber)),
                          ]))
                      .toList(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
