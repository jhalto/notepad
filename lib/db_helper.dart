import 'dart:ffi';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'note.dart';

class DbHelper {
  Future<Database> initDb()async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    return await openDatabase(path, version: 1,onCreate: _onCreate);
  }
  Future _onCreate(Database db, int version)async{
    var sql = ''' CREATE TABLE notepad(id INTEGER PRIMARY KEY, title TEXT, note TEXT )''';
    await db.execute(sql);

  }
  Future <int> createNote(Note note)async{
    var db = await DbHelper().initDb();
    return await db.insert('notepad', note.toMap());

  }
   Future <int> updateNote(Note note)async{
    var db = await DbHelper().initDb();
    return await db.update('notepad', note.toMap(),where: 'id = ?', whereArgs: [note.id]);
  }
  Future<int> deleteNote(int id)async{
    var db = await DbHelper().initDb();
    return await db.delete("notepad",whereArgs: [id],where: 'id = ?');
  }

  Future<List<Note>> readNotes()async{
    Database db = await DbHelper().initDb();
    var note = await db.query('notepad');
    List<Note> noteList = note.isNotEmpty ?
    note.map((e) => Note.fromMap(e)).toList()
        :[];
    return noteList;
  }
}