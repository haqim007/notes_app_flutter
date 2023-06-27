import 'dart:convert';
import 'dart:io';

import 'package:notes_app/models/note.dart';
import 'package:http/http.dart' as http;

class NoteAPI{

  NoteAPI._privateConstructor();

  static final NoteAPI _instance = NoteAPI._privateConstructor();

  factory NoteAPI() {
    return _instance;
  }

  final _urlString = "https://latihan-firebase-90d51-default-rtdb.firebaseio.com/notes";


  Future<List<Note>> getNotes() async{
    
    try {
      final response = await http.get(Uri.parse("$_urlString.json"));
      final results = jsonDecode(response.body) as Map<String, dynamic>;
      List<Note> notes = [];

      if (response.statusCode != 200) {
        throw Exception();
      }

      results.forEach((key, value) {
        notes.add(Note(
            id: key,
            title: value['title'],
            note: value['note'],
            isPinned: value['is_pinned'],
            updatedAt: DateTime.parse(value['updated_at']),
            createdAt: DateTime.parse(value['created_at'])));
      });

      return notes;
    }
    on SocketException{
      throw const SocketException("Tidak dapat terhubung ke internet");
    }
     catch (e) {
      throw Exception("Error, terjadi kesalahan");
    }

  }

  Future<String> postNote(Note note) async{
    try{
      Map<String, dynamic> mapNote = {
        "title": note.title,
        "note": note.note,
        "is_pinned": note.isPinned,
        "updated_at": note.updatedAt.toIso8601String(),
        "created_at": note.createdAt.toIso8601String()
      };

      final body = jsonEncode(mapNote);
      final response = await http.post(Uri.parse("$_urlString.json"), body: body);

      if (response.statusCode != 200) {
        throw Exception();
      }

      return jsonDecode(response.body)['name'];
    }
    on SocketException {
      throw const SocketException("Tidak dapat terhubung ke internet");
    } catch (e) {
      throw Exception("Error, terjadi kesalahan");
    }
  }

  Future<void> updateNote(Note note) async{

    try {
      Map<String, dynamic> mapNote = {
        "title": note.title,
        "note": note.note,
        "updated_at": note.updatedAt.toIso8601String()
      };

      final body = jsonEncode(mapNote);

      final response = await http.patch(Uri.parse("$_urlString/${note.id}.json"), body: body);
      
      if (response.statusCode != 200) {
        throw Exception();
      }
    } on SocketException {
      throw const SocketException("Tidak dapat terhubung ke internet");
    } catch (e) {
      throw Exception("Error, terjadi kesalahan");
    }

  }

  Future<void> updatePinned({required String id, required bool isPinned}) async {
    try {
      Map<String, dynamic> mapNote = {"is_pinned": isPinned};

      final body = jsonEncode(mapNote);

      final response = await http.patch(Uri.parse("$_urlString/$id.json"), body: body);
      if (response.statusCode != 200) {
        throw Exception();
      }
    } on SocketException {
      throw const SocketException("Tidak dapat terhubung ke internet");
    } catch (e) {
      throw Exception("Error, terjadi kesalahan");
    }
  }

  Future<void> deleteNote(Note note) async {
    try {
      final response = await http.delete(Uri.parse("$_urlString/${note.id}.json"));
      if (response.statusCode != 200) {
        throw Exception();
      }
    } on SocketException {
      throw const SocketException("Tidak dapat terhubung ke internet");
    } catch (e) {
      throw Exception("Error, terjadi kesalahan");
    }
  }
}