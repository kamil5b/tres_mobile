import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';
import 'LoginPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var user = localStorage.getString('user');

  runApp(
      MaterialApp(
        home: user == null ? LoginPage() : HomePage(),
      )
  );
}
