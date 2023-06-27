import 'package:flutter/material.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import 'note_item.dart';

class NoteGrid extends StatefulWidget {
  const NoteGrid({
    super.key,
  });

  @override
  State<NoteGrid> createState() => _NoteGridState();
}

class _NoteGridState extends State<NoteGrid> {
  @override
  Widget build(BuildContext context) {

    final notesProvider = Provider.of<NotesProvider>(context, listen: true);
    List<Note> notes = notesProvider.notes;

    return GridView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return NoteItem(note: note);
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8));
  }
}
