import 'package:flutter/material.dart';
import 'package:to_do_app/db.dart';
import 'package:to_do_app/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sql_db().opendb();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(primarySwatch: Colors.purple),
    );
  }
}
