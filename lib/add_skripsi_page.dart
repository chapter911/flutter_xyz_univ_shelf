import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xyz_univ_shelf/helper/database_helper.dart';
import 'package:xyz_univ_shelf/home_page.dart';
import 'package:xyz_univ_shelf/style/style.dart';

class AddSkripsiPage extends StatefulWidget {
  const AddSkripsiPage({super.key});

  @override
  State<AddSkripsiPage> createState() => _AddSkripsiPageState();
}

class _AddSkripsiPageState extends State<AddSkripsiPage> {
  final TextEditingController _nim = TextEditingController();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _judul = TextEditingController();
  final TextEditingController _tema = TextEditingController();
  int _id = 0;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      _id = Get.arguments['id'];
      _nim.text = Get.arguments['nim'].toString();
      _nama.text = Get.arguments['nama'];
      _judul.text = Get.arguments['judul'];
      _tema.text = Get.arguments['tema'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_id == 0 ? "Tambah Skripsi" : "Edit Skripsi"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nim,
              decoration: Style().dekorasiInput(hint: "NIM"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nama,
              decoration: Style().dekorasiInput(hint: "Nama"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _judul,
              decoration: Style().dekorasiInput(hint: "Judul"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tema,
              decoration: Style().dekorasiInput(hint: "Tema"),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_nim.text.isEmpty ||
              _nama.text.isEmpty ||
              _judul.text.isEmpty ||
              _tema.text.isEmpty) {
            Get.snackbar("Maaf", "Harap Lengkapi Data Anda Terlebih Dahulu");
          } else {
            DataBaseHelper.getWhere("skripsi", "nim = ${_nim.text}")
                .then((value) {
              if (value.isNotEmpty) {
                Get.snackbar(
                    "Maaf", "Mahasiswa ini Sudah Mengajukan Judul Skripsi");
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Center(child: Text("Simpan Skripsi Ini?")),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                        ),
                        child: const Text(
                          "Batal",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_id == 0) {
                            DataBaseHelper.insert("skripsi", {
                              "nim": _nim.text,
                              "nama": _nama.text,
                              "judul": _judul.text,
                              "tema": _tema.text
                            });
                          } else {
                            DataBaseHelper.update(
                              "skripsi",
                              {
                                "nim": _nim.text,
                                "nama": _nama.text,
                                "judul": _judul.text,
                                "tema": _tema.text
                              },
                              "id = ?",
                              _id,
                            );
                          }
                          Get.offAll(() => const HomePage());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          "Simpan",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            });
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
