import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'team.dart';
import 'teampreview.dart';
import 'settings_page.dart'; // 👈 import หน้าใหม่

class MainPage extends StatelessWidget {
  final PokemonController ctrl = Get.put(PokemonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokémon Team Builder")),
      body: Column(
        children: [
          Expanded(child: PokemonSelectPage()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // ปุ่ม Preview Team
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: ctrl.selected.isEmpty
                            ? null
                            : () => Get.to(() => TeamPreviewPage()),
                        icon: const Icon(Icons.visibility,
                            size: 24, color: Colors.white),
                        label: const Text(
                          "Preview Team",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          disabledBackgroundColor: Colors.grey[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                          shadowColor: Colors.blueAccent,
                        ),
                      ),
                    )),
                const SizedBox(height: 12),

                // ปุ่ม Settings
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () => Get.to(() => const SettingsPage()),
                    icon: const Icon(Icons.settings,
                        size: 24, color: Colors.white),
                    label: const Text(
                      "Go to Settings",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      shadowColor: Colors.greenAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
