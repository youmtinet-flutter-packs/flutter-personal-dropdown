import 'package:flutter/material.dart';

import 'package:personal_dropdown/personal_dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = TextEditingController();
  int selectedPlayer = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomDropdown<int>(
                items: List.generate(10, (index) => index + 1),
                controller: controller,
                listItemBuilder: (context, result) {
                  return Text(
                    'Player $result',
                    style: TextStyle(
                      color: result == selectedPlayer ? Colors.red : null,
                      fontSize: result == selectedPlayer ? 18 : null,
                      fontWeight: result == selectedPlayer ? FontWeight.bold : null,
                    ),
                  );
                },
                onItemSelect: (item) {
                  setState(() {
                    selectedPlayer = item;
                  });
                },
              ),
              Text(
                'Selected Player is $selectedPlayer',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: controller,
              )
            ]
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: e,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
