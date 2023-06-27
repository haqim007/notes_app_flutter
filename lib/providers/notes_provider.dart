import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:notes_app/api/note_api.dart';
import 'package:notes_app/database/database_helper.dart';
import 'package:notes_app/models/note.dart';

class NotesProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  List<Note> _notes = [
    // Note(
    //   id: 'N1',
    //   title: 'Catatan Materi Flutter',
    //   note:
    //       'Flutter merupakan Software Development Kit (SDK) yang bisa membantu developer dalam membuat aplikasi mobile cross platform. Kelas ini akan mempelajari pengembangan aplikasi mobile yang dapat dijalankan baik di IOS maupun di Android',
    //   updatedAt: DateTime.parse('2021-05-19 20:33:33'),
    //   createdAt: DateTime.parse('2021-05-19 20:33:33'),
    // ),
    // Note(
    //   id: 'N2',
    //   title: 'Target Pembelajaran Flutter',
    //   note:
    //       'Peserta dapat mengembangkan aplikasi mobile (IOS dan Android) menggunakan flutter,\nPeserta memahami konsep pengembangan aplikasi menggunakan flutter,\nPeserta dapat menjalankan aplikasi mobile di IOS dan Android ataupun Emulator,\nPeserta memahami bahasa pemrograman Dart,\nPeserta dapat mendevelop aplikasi mobile menggunakan flutter dan dart dari dasar secara berurutan.',
    //   updatedAt: DateTime.parse('2021-05-20 20:53:33'),
    //   createdAt: DateTime.parse('2021-05-20 20:53:33'),
    // ),
    // Note(
    //   id: 'N3',
    //   title: 'Belajar Flutter di ITBOX',
    //   note: 'Jangan lupa belajar flutter dengan video interactive di ITBOX.',
    //   updatedAt: DateTime.parse('2021-05-20 21:22:33'),
    //   createdAt: DateTime.parse('2021-05-20 21:22:33'),
    // ),
    // Note(
    //   id: 'N4',
    //   title: 'Resep nasi goreng',
    //   note:
    //       'Nasi putih 1 piring\nBawang putih 2 siung, cincang halus\nKecap manis atau kecap asin sesuai selera\nSaus sambal sesuai selera\nSaus tiram sesuai selera\nGaram secukupnya\nKaldu bubuk rasa ayam atau sapi sesuai selera\nDaun bawang 1 batang, cincang halus\nTelur ayam 1 butir\nSosis ayam 1 buah, iris tipis\nMargarin atau minyak goreng 3 sdm.',
    //   updatedAt: DateTime.parse('2021-05-20 21:51:33'),
    //   createdAt: DateTime.parse('2021-05-20 21:51:33'),
    // ),
  ];

  Note getNote(String noteId) {
    int index = _notes.indexWhere((element) => element.id == noteId);
    return _notes[index];
  }

  List<Note> get notes {
    return _notes;
  }

  final _api = NoteAPI();
  final _db = DatabaseHelper();

  Future<void> _futureNetworkCallback(Function() callback) async{
    try {
      await callback();
    } catch (e) {
      return Future.error(e);
    }
    notifyListeners();

  }

  Future<void> getNotes() async {

    // try {
    //   _notes = await _api.getNotes();
    // } on SocketException{
    //   notifyListeners();
    //   return;
    // } catch (e) {
    //   return Future.error(e);
    // }
    // notifyListeners();
    await _futureNetworkCallback(() async{
      try {
        List<Note> notesFromApi = await _api.getNotes();
        await _db.deleteAllNotes();
        await _db.insertAllNotes(notesFromApi);
        _notes = await _db.getNotes();
      } on SocketException{
         _notes = await _db.getNotes();
         notifyListeners();
      }
      catch(e){
        throw Exception(e);
      }
    });

  }

  Future<void> togglePin(Note note) async{
    // try {
    //   await _api.updatePinned(id: note.id, isPinned: !note.isPinned);
    //   int index = _notes.indexWhere((element) => element.id == note.id);
    //   _notes[index].isPinned = !note.isPinned;
    // } on SocketException {
    //   notifyListeners();
    //   return;
    // } catch (e) {
    //   return Future.error(e);
    // }
    // notifyListeners();

    await _futureNetworkCallback(() async {
        await _api.updatePinned(id: note.id, isPinned: !note.isPinned);
        await _db.updateNotePinned(id: note.id, isPinned: !note.isPinned);
        int index = _notes.indexWhere((element) => element.id == note.id);
        _notes[index].isPinned = !note.isPinned;
    });
  }

  Future<void> addNote(Note note) async{
  //  try {
  //     _notes = await _api.getNotes();
  //   } on SocketException {
  //     notifyListeners();
  //     return;
  //   } catch (e) {
  //     return Future.error(e);
  //   }
  //   notifyListeners();

    await _futureNetworkCallback(() async {
      final now = DateTime.now();
      final id = await _api.postNote(note.copyWith(createdAt: now, updatedAt: now));
      await _db.insertNote(note.copyWith(id: id));
      
      _notes.add(note.copyWith(id: id));
    });
  }

  Future<void> updateNote(Note note) async{
    await _futureNetworkCallback(() async {
      final now = DateTime.now();
      Note newNote = note.copyWith(updatedAt: now);
      await _api.updateNote(newNote);
      await _db.updateNote(newNote);
      int index = _notes.indexWhere((element) => element.id == note.id);
      _notes[index] = newNote;
      // notifyListeners();
    });
  }

  Future<void> deleteNote(Note note)async{
    await _futureNetworkCallback(() async {
      await _api.deleteNote(note);
      await _db.deleteNote(note);
      _notes.remove(note);
      // notifyListeners();
    });
  }



}