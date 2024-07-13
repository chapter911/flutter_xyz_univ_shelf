import 'package:flutter/material.dart';

class Style {
  String hint = "";
  Icon? icon;
  IconButton? suffixIcon;
  Color warna = Colors.blueAccent;
  InputDecoration dekorasiInput({hint, icon, suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      label: Text(hint),
      prefixIcon: icon,
      suffixIcon: suffixIcon,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.black12,
          width: .5,
        ),
      ),
    );
  }
}
