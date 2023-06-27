import 'package:flutter/material.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:notes_app/screens/add_or_detail_note_screen.dart';
import 'package:provider/provider.dart';


import '../widgets/note_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

// before using Provider
  // List<Note> notesList = [];

  // void togglePin(Note note){
  //   int index = notesList.indexWhere((element) => element == note);
  //   setState(() {
  //     notesList[index].isPinned = !notesList[index].isPinned;
  //   });
  // }

  // void addNote(Note note){
  //   setState(() {
  //     notesList.add(note);
  //   });
  // }

// After

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: Provider.of<NotesProvider>(context, listen: false).getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          
          return Container(
            margin: const EdgeInsets.all(16.0),
            // child: ListView.builder(
            //   itemCount: notes.length,
            //   itemBuilder: (context, index) {
            //     final item = notes[index];
            //     return Card(
            //       color: Colors.red[50],
            //       elevation: 2.0,
            //       child: ListTile(
            //         title: Text(item.title),
            //         subtitle: Text(item.note),
            //       )
            //     );
            //   }
            // ),
        
            //child: NoteGrid(notes: notesList, togglePin: togglePin),
            child: const NoteGrid(),
          );
        }
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (builder){
          //     // AddNoteScreen(addNote: addNote)
          //     return const AddOrDetailNoteScreen();
          //   })
          // );
          Navigator.of(context).pushNamed(AddOrDetailNoteScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
      
    );
  }
}
