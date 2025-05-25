import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static DBHelper getInstance() {
    return DBHelper._();
  }

  Database? mDB;

  static const String notesTable = "notes";
  static const String noteIDColumn = "note_id";
  static const String noteTitleColumn = "note_title";
  static const String noteDescColumn = "note_desc";
  static const String noteCreatedAtColumn = "note_created_at";
  static const String noteUpdatedAtColumn = "note_updated_at";

  Future<Database> initDB() async {
    if (mDB == null) {
      mDB = await openDB();
      return mDB!;
    } else {
      return mDB!;
    }
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    String dbPath = join(appDir.path, "noteDB.db");

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "create table $notesTable ( $noteIDColumn integer primary key autoincrement, $noteTitleColumn text, $noteDescColumn text, $noteCreatedAtColumn text, $noteUpdatedAtColumn text)",
        );
      },
    );
  }

  Future<void> addNote({required String title, required String desc}) async {
    var db = await initDB();

    int now = DateTime.now().millisecondsSinceEpoch;

    await db.insert(notesTable, {
      noteTitleColumn: title,
      noteDescColumn: desc,
      noteCreatedAtColumn: now.toString(),
      noteUpdatedAtColumn: now.toString(),
    });
  }

  Future<List<Map<String, dynamic>>> fetchAllNotes() async {
    var db = await initDB();

    return await db.query(notesTable);
  }

  Future<void> updateNote({
    required int noteId,
    required String title,
    required String desc,
  }) async {
    var db = await initDB();

    int now = DateTime.now().millisecondsSinceEpoch;

    await db.update(
      notesTable,
      {
        noteTitleColumn: title,
        noteDescColumn: desc,
        noteUpdatedAtColumn: now.toString(),
      },
      where: '$noteIDColumn = ?',
      whereArgs: [noteId],
    );
  }

  void deleteNote({required int noteId}) async {
    var db = await initDB();

    await db.delete(
      notesTable,
      where: '$noteIDColumn = ?',
      whereArgs: [noteId],
    );
  }
}
