import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'team.dart';

class TeamListPage extends StatelessWidget {
  final PokemonController ctrl = Get.find<PokemonController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Teams")),
      body: Obx(() {
        if (ctrl.allTeams.isEmpty) {
          return const Center(
            child: Text(
              "ยังไม่มีทีมที่บันทึก",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: ctrl.allTeams.length,
          itemBuilder: (context, index) {
            final team = ctrl.allTeams[index];
            final teamName = team['name'];
            final members = team['members'] as List<dynamic>;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ListTile(
                title: Text(teamName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("${members.length} Pokémon"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                },
              ),
            );
          },
        );
      }),
    );
  }
}
