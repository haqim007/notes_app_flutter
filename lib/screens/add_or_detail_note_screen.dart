import 'package:flutter/material.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class AddOrDetailNoteScreen extends StatefulWidget {

  static const routeName = "/addOrDetailScreen";

  const AddOrDetailNoteScreen({
    super.key,
  });

  @override
  State<AddOrDetailNoteScreen> createState() => _AddOrDetailNoteScreenState();
}

class _AddOrDetailNoteScreenState extends State<AddOrDetailNoteScreen> {

  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;

  Note _note = Note(
    id: "",
    title: "",
    note: "",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now() 
  );


  bool _hasInitDependencies = false;
  @override
  void didChangeDependencies() {
    if(!_hasInitDependencies){
      _note = ModalRoute.of(context)?.settings.arguments as Note? ?? _note;
      _hasInitDependencies = true;
    }
    super.didChangeDependencies();
  }

  void submitNote() async{
    setState(() {
      _isSubmitting = true;
    });
    
    try {
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      _formKey.currentState?.save();

      if (_note.id.isEmpty) {
        await notesProvider.addNote(_note);
      } else {
        await notesProvider.updateNote(_note);
      }

      afterSubmitNote();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()))
      );
    } finally{
        setState(() {
        _isSubmitting = false;
      });
    }

    
  }

  void afterSubmitNote(){
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Note ${_note.id.isEmpty ? "added" : "updated"} successfully")));

    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  String _convertDate(DateTime dateTime){
    Duration diff = DateTime.now().difference(dateTime);
    if (diff.inDays == 0) {
      return "${diff.inHours.toString()} hours ago";
    }else{
      return "${diff.inDays.toString()} days ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_note.id.isEmpty ? "Add Note" : "Edit Note"),
        actions: [
          _isSubmitting ? const CircularProgressIndicator() : TextButton(
            onPressed: (){
              submitNote();
            }, child: const Text("Simpan")
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.maxFinite,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Judul",
                        border: InputBorder.none,
                      ),
                      onSaved: (value) => {_note = _note.copyWith(title: value)},
                      initialValue: _note.title,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                    
                    TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Catatan", border: InputBorder.none),
                        onSaved: (value) => {_note = _note.copyWith(note: value)},
                        initialValue: _note.note,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                    
                  ],
                ),
              ),
            )
          ),

          Positioned(
                      bottom: 10,
                      right: 10,
                      child: Text(
                          "Terakhir diubah ${_convertDate(_note.updatedAt)}"
                      )
                  )
        ],
        
      ),
     
    );
  }
}