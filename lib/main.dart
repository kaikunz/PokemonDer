import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'pokemon/team.dart';

void main() async  {
  await GetStorage.init();
  Get.put(ApiService());
  Get.put(PokemonController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TeamBuilder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PokemonSelectPage(),
    );
  }
}