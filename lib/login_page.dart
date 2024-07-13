import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xyz_univ_shelf/helper/sharedpreferences.dart';

import 'home_page.dart';
import 'style/style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((value) {
      if (Prefs.checkData("username") == true) {
        Get.offAll(() => const HomePage());
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/university.png'),
              const SizedBox(height: 10),
              const Text(
                "XYZ University",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 10),
              _isLoading
                  ? const CupertinoActivityIndicator()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _username,
                          decoration: Style().dekorasiInput(
                            hint: "username",
                            icon: const Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _password,
                          obscureText: true,
                          decoration: Style().dekorasiInput(
                            hint: "password",
                            icon: const Icon(Icons.password),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_username.text == "admin" &&
                                  _password.text == "123") {
                                Prefs().saveString("username", _username.text);
                                Get.offAll(() => const HomePage());
                              } else {
                                Get.snackbar(
                                  "Maaf",
                                  "username / password yang anda masukkan salah",
                                  backgroundColor: Colors.red[900],
                                  colorText: Colors.white,
                                );
                              }
                            },
                            child: const Text("LOGIN"),
                          ),
                        )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
