

import 'package:notes_app/database/database_helper.dart';

class Note {
  final String id;
  final String title;
  final String note;
  final DateTime updatedAt;
  final DateTime createdAt;
  bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.note,
    required this.updatedAt,
    required this.createdAt,
    this.isPinned = false
  });

  Note copyWith({
    String? id,
    String? title,
    String? note,
    DateTime? updatedAt,
    DateTime? createdAt,
    bool? isPinned,
  }){
    return Note(
      id: id ?? this.id, 
      title: title ?? this.title, 
      note: note ?? this.note, 
      updatedAt: updatedAt ?? this.updatedAt, 
      createdAt: createdAt ?? this.createdAt
    );
  }

  Note.fromdb(Map<String, dynamic> data):
    id = data[DatabaseHelper.TABLE_NOTES_COLUMN_ID],
    title = data[DatabaseHelper.TABLE_NOTES_COLUMN_TITLE],
    note = data[DatabaseHelper.TABLE_NOTES_COLUMN_NOTE],
    createdAt = DateTime.parse(data[DatabaseHelper.TABLE_NOTES_COLUMN_CREATED_AT]),
    updatedAt = DateTime.parse(data[DatabaseHelper.TABLE_NOTES_COLUMN_UPDATED_AT]),
    isPinned = data[DatabaseHelper.TABLE_NOTES_COLUMN_IS_PINNED] as int == 1;

  Map<String, dynamic> toDb(){
    return {
          DatabaseHelper.TABLE_NOTES_COLUMN_ID : id,
          DatabaseHelper.TABLE_NOTES_COLUMN_TITLE : title,
          DatabaseHelper.TABLE_NOTES_COLUMN_NOTE : note,
          DatabaseHelper.TABLE_NOTES_COLUMN_IS_PINNED : isPinned ? 1 : 0,
          DatabaseHelper.TABLE_NOTES_COLUMN_CREATED_AT : createdAt.toIso8601String(),
          DatabaseHelper.TABLE_NOTES_COLUMN_UPDATED_AT : updatedAt.toIso8601String()
        };
  }
    


}
