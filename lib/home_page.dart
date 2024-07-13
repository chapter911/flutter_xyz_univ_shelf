import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xyz_univ_shelf/add_skripsi_page.dart';
import 'package:xyz_univ_shelf/helper/database_helper.dart';
import 'package:xyz_univ_shelf/helper/sharedpreferences.dart';

import 'login_page.dart';
import 'style/style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _pencarian = TextEditingController();
  final List<Widget> _dataSkripsi = [];
  @override
  void initState() {
    super.initState();
    getSkripsi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/university.png'),
        ),
        title: const Text("XYZ University"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Keluar Aplikasi?"),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("Batal"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Prefs().clearData();
                        Get.offAll(() => const LoginPage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[900],
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.power_settings_new,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              controller: _pencarian,
              decoration: Style().dekorasiInput(hint: "Cari"),
              onChanged: (value) {
                _pencarian.text = value;
                getSkripsi();
              },
            ),
          ),
          Column(children: _dataSkripsi),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddSkripsiPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void getSkripsi() {
    String where = "";
    if (_pencarian.text.isNotEmpty) {
      where =
          "WHERE nim LIKE '%${_pencarian.text}%' OR nama LIKE '%${_pencarian.text}%' OR judul LIKE '%${_pencarian.text}%' OR tema LIKE '%${_pencarian.text}%'";
    }

    DataBaseHelper.customQuery("SELECT * FROM skripsi $where").then((value) {
      _dataSkripsi.clear();
      for (int i = 0; i < value.length; i++) {
        _dataSkripsi.add(
          Container(
            margin: const EdgeInsets.all(5),
            width: double.maxFinite,
            child: Card(
              elevation: 10,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  Get.to(
                    () => const AddSkripsiPage(),
                    arguments: value[i],
                  );
                },
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      color: Colors.blue,
                      padding: const EdgeInsets.all(5),
                      child: Center(
                        child: Text(
                          "${value[i]['nim']}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Table(
                        border: const TableBorder(
                          horizontalInside: BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                            color: Colors.black,
                          ),
                        ),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const <int, TableColumnWidth>{
                          0: FractionColumnWidth(0.3),
                          1: FractionColumnWidth(0.05),
                          2: FractionColumnWidth(0.65),
                        },
                        children: [
                          TableRow(children: [
                            const Text(
                              "Nama",
                            ),
                            const Text(
                              ":",
                            ),
                            Text(
                              value[i]['nama'],
                              textAlign: TextAlign.end,
                            ),
                          ]),
                          TableRow(children: [
                            const Text(
                              "Judul",
                            ),
                            const Text(
                              ":",
                            ),
                            Text(
                              value[i]['judul'],
                              textAlign: TextAlign.end,
                            ),
                          ]),
                          TableRow(children: [
                            const Text(
                              "Tema",
                            ),
                            const Text(
                              ":",
                            ),
                            Text(
                              value[i]['tema'],
                              textAlign: TextAlign.end,
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      setState(() {});
    });
  }
}
