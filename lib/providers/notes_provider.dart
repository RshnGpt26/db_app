import 'dart:math';

import 'package:flutter/material.dart';

import '../services/db_helper.dart';

class NotesProvider extends ChangeNotifier {
  DBHelper? _dbHelper;

  List<Map<String, dynamic>> _mNotes = [];
  List<Color> _colors = [];

  Map<String, dynamic> _note = {};

  List<Map<String, dynamic>> get mNotes => _mNotes;

  Map<String, dynamic> get note => _note;

  List<Color> get colors => _colors;

  set note(Map<String, dynamic> value) => _note = value;

  init() {
    _dbHelper = DBHelper.getInstance();
    getAllNotes();
  }

  getAllNotes() async {
    _mNotes = await _dbHelper!.fetchAllNotes();
    if (_mNotes.isNotEmpty) {
      generateColors();
    }
    notifyListeners();
  }

  generateColors() {
    _colors = List.generate(
      _mNotes.length,
      (index) => Color.fromARGB(
        255,
        Random().nextInt(256),
        Random().nextInt(256),
        Random().nextInt(256),
      ),
    );
  }

  onAddSave(
    BuildContext context, {
    required String title,
    required String desc,
  }) async {
    bool status = isValidText(context, title: title, desc: desc);
    if (status) {
      await _dbHelper!.addNote(title: title.trim(), desc: desc.trim());
      await getAllNotes();
    }
  }

  onUpdateSave(
    BuildContext context, {
    required int index,
    required String title,
    required String desc,
  }) async {
    bool status = isValidText(context, title: title, desc: desc);
    if (status) {
      await _dbHelper!.updateNote(
        noteId: _note[DBHelper.noteIDColumn],
        title: title.trim(),
        desc: desc.trim(),
      );
      await getAllNotes();
      note = _mNotes[index];
      notifyListeners();
    }
  }

  bool isValidText(
    BuildContext context, {
    required String title,
    required String desc,
  }) {
    bool status = true;
    if (title.trim().isEmpty && desc.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter values."),
          duration: Duration(seconds: 2),
        ),
      );
      status = false;
    }
    return status;
  }
}
