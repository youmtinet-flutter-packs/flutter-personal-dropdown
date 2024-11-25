import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:personal_dropdown/personal_dropdown.dart';

void main() {
  runApp(const MyApp());
}

const Color primaryDark = Color(0xFF01DF44);

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
    log(MediaQuery.of(context).size.width.toString());
    return MaterialApp(
      theme: theme(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 20),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /* CustomDropdown<int>.search(
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
                  searchFunction: (int item, String searchPrompt) {
                    return 'Player $item'.contains(searchPrompt);
                  },
                  searchableTextItem: (int item) {
                    return '$item';
                  },
                ), */
                CustomDropdown<String>.search(
                  items: List.generate(4, (index) => '${index + 1}'),
                  controller: controller,
                  itemBgColor: Colors.amber,
                  listItemBuilder: (context, result) {
                    return Text(
                      result,
                      style: TextStyle(
                        color: result == '$selectedPlayer' ? Colors.red : null,
                        fontSize: result == '$selectedPlayer' ? 18 : null,
                        fontWeight: result == '$selectedPlayer' ? FontWeight.bold : null,
                      ),
                    );
                  },
                  onItemSelect: (item) {
                    setState(() {
                      selectedPlayer = int.parse(item);
                    });
                  },
                  searchFunction: (item, String searchPrompt) {
                    return 'Player $item'.contains(searchPrompt);
                  },
                  searchableTextItem: (item) {
                    return item;
                  },
                ),
                Text(
                  'Selected Player is $selectedPlayer',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                  ),
                ),
                TextField(controller: controller),
              ]
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: e,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  ThemeData theme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.grey.shade900,
      colorScheme: const ColorScheme.dark(
        primary: primaryDark,
        error: Color(0xFF85120A),
        surface: Colors.black,
      ),
      brightness: Brightness.dark,
      dialogBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        //color: Colo rs.black,
        elevation: 5,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontFamily: "WORK SANS",
          fontWeight: FontWeight.bold,
        ),
      ),
      primaryTextTheme: const TextTheme(),
      inputDecorationTheme: () {
        OutlineInputBorder outlineInputBorder = OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
          gapPadding: 10,
        );
        return InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.only(
            right: 32,
            top: 10,
            left: 32,
            bottom: 10,
          ),
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
        );
      }(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
