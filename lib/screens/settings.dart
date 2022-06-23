import 'package:flutter/material.dart';
import 'package:ccr_multistore_app/helpers/themes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            onTap: () {
              currentTheme.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
