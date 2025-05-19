import 'package:flutter/material.dart';

import 'db_helper.dart';
import 'notes_add_update.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DB Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  List<Map<String, dynamic>> mNotes = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper.getInstance();
    getAllNotes();
  }

  getAllNotes() async {
    mNotes = await dbHelper!.fetchAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
      body:
          mNotes.isNotEmpty
              ? ListView.builder(
                itemCount: mNotes.length,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(mNotes[index]["note_title"] ?? ""),
                    subtitle: Text(mNotes[index]["note_desc"] ?? ""),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: NotesAddUpdate(
                                    isAdding: false,
                                    oldTitle: mNotes[index]["note_title"],
                                    oldDesc: mNotes[index]["note_desc"],
                                    onAddUpdate: (title, desc) {
                                      if (title.isEmpty && desc.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Please enter values.",
                                            ),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        return;
                                      }
                                      dbHelper!.updateNote(
                                        noteId: mNotes[index]["note_id"],
                                        title: title,
                                        desc: desc,
                                      );
                                      getAllNotes();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.edit, color: Colors.green),
                        ),
                        IconButton(
                          onPressed: () {
                            dbHelper!.deleteNote(
                              noteId: mNotes[index]["note_id"],
                            );
                            getAllNotes();
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  );
                },
              )
              : Center(child: Text("No Notes yet!!")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: NotesAddUpdate(
                  isAdding: true,
                  onAddUpdate: (title, desc) {
                    if (title.isEmpty && desc.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter values."),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    dbHelper!.addNote(title: title, desc: desc);
                    getAllNotes();
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
