import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pokemon/mainpage.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokémon Team Builder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPage(),
    );
  }
}