import 'package:flutter/material.dart';
import 'package:notes_app/icons/custom_icon_icons.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:notes_app/screens/add_or_detail_note_screen.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';


class NoteItem extends StatefulWidget {
  const NoteItem({
    super.key,
    required this.note,
  });

  final Note note;
  

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {

  // late Note _note;
  
  @override
  void initState() {
    super.initState();
    // _note = widget.note;
  }

  @override
  Widget build(BuildContext context) {
    // return Card(
    //     color: Colors.red[50],
    //     elevation: 2.0,
    //     child: GridTile(
    //       header: GridTileBar(
    //         backgroundColor: Colors.black54,
    //         title: Text(item.title),
    //       ),
    //       child: Container(
    //         margin: const EdgeInsets.only(
    //             left: 16.0, right: 16.0, top: 50.0, bottom: 16.0),
    //         child: Text(
    //           item.note,
    //           overflow: TextOverflow.ellipsis,
    //           maxLines: 5,
    //         ),
    //       ),
    //     ));

    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    Note note = notesProvider.getNote(widget.note.id);

    return Dismissible(
      key: Key(note.id),
      confirmDismiss: (direction) async{
        try {
          await notesProvider.deleteNote(note);
          return true;
        } catch (e) {
           ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
          return false; 
        }
      },
      child: GestureDetector(
        onTap: () => {
          Navigator.of(context).pushNamed(
            AddOrDetailNoteScreen.routeName,
            arguments: note
          )
        },
        child: GridTile(
          header: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              iconSize: 16.0,
              onPressed: () {
                notesProvider.togglePin(note)
                  .catchError((e){
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  });
              },
              icon: note.isPinned ? const Icon(CustomIcon.pin) : const Icon(CustomIcon.pinOutline)
            ),
          ),
          footer: ClipRRect(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
            child: GridTileBar(
              title: Text(note.title),
              backgroundColor: Colors.black54,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.only(top:24.0, left: 16.0, right: 24.0, bottom: 16.0),
            child: Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      note.note, 
                      overflow: TextOverflow.ellipsis, 
                      maxLines: 4,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
