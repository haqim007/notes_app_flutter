import 'dart:ffi';

import 'package:notes_app/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

  final Future<Database> _database;

  DatabaseHelper() : _database = _init();

  Future<Database> get database => _database;

  static const TABLE_NAME = "notes";
  static const TABLE_NOTES_COLUMN_ID = "id";
  static const TABLE_NOTES_COLUMN_TITLE = "title";
  static const TABLE_NOTES_COLUMN_NOTE = "note";
  static const TABLE_NOTES_COLUMN_IS_PINNED = "isPinned";
  static const TABLE_NOTES_COLUMN_CREATED_AT = "createdAt";
  static const TABLE_NOTES_COLUMN_UPDATED_AT = "updatedAt";

  static Future<Database> _init() async{
    final dbPath = await getDatabasesPath();

    return openDatabase(
      join(dbPath, "notes.db"),
      version: 1,
      onCreate: (newDb, version){
        newDb.execute('''
          CREATE TABLE notes (
            $TABLE_NOTES_COLUMN_ID TEXT PRIMARY KEY,
            $TABLE_NOTES_COLUMN_TITLE TEXT,
            $TABLE_NOTES_COLUMN_NOTE TEXT,
            $TABLE_NOTES_COLUMN_IS_PINNED INTEGER,
            $TABLE_NOTES_COLUMN_CREATED_AT TEXT,
            $TABLE_NOTES_COLUMN_UPDATED_AT Text
          )
        
        ''');
      }
    );
  }

  Future<List<Note>> getNotes() async{
    final db = await DatabaseHelper._init();
    final results = await db.query(TABLE_NAME);

    List<Note> notes = [];
    for (var element in results) {
      notes.add(Note.fromdb(element));
    }

    return notes;
  }

  Future<void> deleteAllNotes() async{
    final db = await DatabaseHelper._init();
    await db.delete(TABLE_NAME);
  }

  Future<void> insertAllNotes(List<Note> notes) async{
    final db = await DatabaseHelper._init();
    Batch batch = db.batch();

    for (var element in notes) {
      batch.insert(TABLE_NAME, element.toDb(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    batch.commit();

  }

  Future<void> insertNote(Note note) async {
    final db = await DatabaseHelper._init();
    await db.insert(TABLE_NAME, note.toDb());
  }

  Future<void> updateNote(Note note) async {
    final db = await DatabaseHelper._init();
    await db.update(TABLE_NAME, note.toDb(), where: "$TABLE_NOTES_COLUMN_ID = ?", whereArgs: [note.id]);
  }

  Future<void> deleteNote(Note note) async {
    final db = await DatabaseHelper._init();
    await db.delete(TABLE_NAME,
        where: "$TABLE_NOTES_COLUMN_ID = ?", whereArgs: [note.id]);
  }

  Future<void> updateNotePinned({required String id, required bool isPinned}) async {
    final db = await DatabaseHelper._init();
    await db.update(TABLE_NAME, {
      TABLE_NOTES_COLUMN_IS_PINNED: (isPinned ? 1 : 0)
    }, where: "$TABLE_NOTES_COLUMN_ID = ?", whereArgs: [id]);
  }
}