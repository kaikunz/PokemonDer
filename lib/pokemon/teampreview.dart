import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'team.dart';

class TeamPreviewPage extends StatelessWidget {
  final PokemonController ctrl = Get.find<PokemonController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text("Team: ${ctrl.teamName.value}")),
        centerTitle: true,
      ),
      body: Obx(() {
        if (ctrl.selected.isEmpty) {
          return const Center(
            child: Text(
              "ยังไม่ได้เลือก Pokémon",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
          ),
          itemCount: ctrl.selected.length,
          itemBuilder: (context, index) {
            final p = ctrl.selected[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(p.imageUrl),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    p.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}