import 'package:flutter/material.dart';
import 'screens/simple_chat_page.dart';

void main() {
  runApp(const MaterialApp(
    home: SimpleChatPage(),
    debugShowCheckedModeBanner: false, // Tambahan: menghilangkan banner debug
  ));
}