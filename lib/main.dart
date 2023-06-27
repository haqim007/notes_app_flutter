import 'package:flutter/material.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:notes_app/screens/add_or_detail_note_screen.dart';
import 'package:notes_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotesProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        routes: {
          AddOrDetailNoteScreen.routeName: (context) => const AddOrDetailNoteScreen(),
        },
      ),
    );
  }
}
