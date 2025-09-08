import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:math';

class Pokemon {
  final String name;
  final String imageUrl;

  Pokemon({required this.name, required this.imageUrl});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('url')) {
      final url = json['url'] as String;
      final id = url.split('/')[url.split('/').length - 2];
      return Pokemon(
        name: json['name'],
        imageUrl:
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png",
      );
    } else {
      return Pokemon(
        name: json['name'],
        imageUrl: json['imageUrl'],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pokemon &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => name.hashCode ^ imageUrl.hashCode;
}



class ApiService extends GetConnect {
  Future<List<Pokemon>> fetchPokemons() async {
    final response = await get("https://pokeapi.co/api/v2/pokemon?limit=20");
    if (response.statusCode == 200) {
      return (response.body['results'] as List)
          .map((p) => Pokemon.fromJson(p))
          .toList();
    }
    return [];
  }
}


class PokemonController extends GetxController {
  var pokemons = <Pokemon>[].obs;
  var selected = <Pokemon>[].obs;
  var teamName = "My Team".obs;
  var query = "".obs;
  var allTeams = <Map<String, dynamic>>[].obs;

  final box = GetStorage();
  final ApiService api = Get.put(ApiService());
  
  

  @override
  void onInit() {
    super.onInit();
    teamName.value = box.read('teamName') ?? "My Team";
    final saved = box.read('team') ?? [];
    selected.value = saved.map<Pokemon>((e) => Pokemon(name: e['name'], imageUrl: e['imageUrl'])).toList();
    final savedTeams = box.read('allTeams') ?? [];
    allTeams.value = List<Map<String, dynamic>>.from(savedTeams);
    loadPokemons();
  }

  void loadPokemons() async {
    pokemons.value = await api.fetchPokemons();
  }

  void toggleSelect(Pokemon p, context) {
    if (selected.contains(p)) {
      selected.remove(p);
    } else {
      if (selected.length < 3) {
        selected.add(p);
      } else {
        Get.snackbar("Warning", "เลือกได้สูงสุด 3 ตัว");
      }
    }
    saveTeam();
  }

  void saveTeam() {
    box.write('team', selected.map((p) => p.toJson()).toList());
  }

  void saveTeamName(String name) {
    teamName.value = name;
    box.write('teamName', name);
  }

  void resetTeam() {
    selected.clear();
    saveTeam();
  }

   void saveCurrentTeam() {
    if (selected.isEmpty) {
      Get.snackbar("Error", "ยังไม่ได้เลือก Pokémon");
      return;
    }
    final score = Random().nextInt(10) + 1;

    final newTeam = {
      "name": teamName.value,
      "members": selected.map((p) => p.toJson()).toList(),
      "score": score,
    };

    allTeams.add(newTeam);
    box.write('allTeams', allTeams);
    selected.clear();
    teamName.value = "My Team";
    Get.snackbar("สำเร็จ", "บันทึกทีมแล้ว!");
  }

  List<Pokemon> get filteredPokemons {
    if (query.value.isEmpty) return pokemons;
    return pokemons
        .where((p) => p.name.toLowerCase().contains(query.value.toLowerCase()))
        .toList();
  }
}


class PokemonSelectPage extends StatelessWidget {
  final PokemonController ctrl = Get.put(PokemonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(ctrl.teamName.value)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final textCtrl = TextEditingController(text: ctrl.teamName.value);
              Get.defaultDialog(
                title: "แก้ไขชื่อทีม",
                content: Column(
                  children: [
                    TextField(
                      controller: textCtrl,
                      decoration: const InputDecoration(
                        hintText: "กรอกชื่อทีม",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("ยกเลิก"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (textCtrl.text.isNotEmpty) {
                              ctrl.saveTeamName(textCtrl.text);
                            }
                            Get.back();
                          },
                          child: const Text("ยืนยัน"),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: ctrl.resetTeam,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "ค้นหา Pokémon",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => ctrl.query.value = value,
            ),
          ),

          Obx(() => Container(
                width: double.infinity,
                color: Colors.grey[200],
                padding: const EdgeInsets.all(8),
                child: ctrl.selected.isEmpty
                    ? const Text("ยังไม่ได้เลือก Pokémon")
                    : Wrap(
                        spacing: 8,
                        children: ctrl.selected.map((p) {
                          return Chip(
                            avatar: CircleAvatar(
                              backgroundImage: NetworkImage(p.imageUrl),
                            ),
                            label: Text(p.name),
                            onDeleted: () => ctrl.selected.remove(p),
                          );
                        }).toList(),
                      ),
              )),

          Expanded(
            child: Obx(() {
              if (ctrl.pokemons.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              final list = ctrl.filteredPokemons;
              if (list.isEmpty) {
                return const Center(
                  child: Text(
                    "ไม่พบผลลัพธ์",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final p = list[index];
                  final isSelected = ctrl.selected.contains(p);

                  return Obx(() {
                    final isSelected = ctrl.selected.contains(p);
                    return GestureDetector(
                      onTap: () => ctrl.toggleSelect(p, context),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue[100] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedScale(
                              scale: isSelected ? 1.2 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundImage: NetworkImage(p.imageUrl),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(p.name),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: Colors.blue),
                          ],
                        ),
                      ),
                    );
                  });
                },
              );
            }),
          ),

        ],
      ),
    );
  }
}
