import 'package:db_example/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../routes/app_routes.dart';
import '../services/db_helper.dart';

class NoteDetailsScreen extends StatefulWidget {
  const NoteDetailsScreen({super.key, required this.note});

  final Map<String, dynamic> note;

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  DBHelper? dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        leadingWidth: 0,
        title: AppButton(
          icon: Icons.keyboard_arrow_left,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          AppButton(
            icon: Icons.edit,
            onPressed: () async {
              Navigator.of(context).pushNamed(
                AppRoutes.noteAddUpdate,
                arguments: {
                  "isAdding": false,
                  "onSaveClick": (String title, String desc) async {
                    if (title.trim().isEmpty && desc.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter values."),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    await dbHelper!.updateNote(
                      noteId: widget.note[DBHelper.noteIDColumn],
                      title: title.trim(),
                      desc: desc.trim(),
                    );
                  },
                  "oldTitle": widget.note[DBHelper.noteTitleColumn],
                  "oldDesc": widget.note[DBHelper.noteDescColumn],
                },
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.note[DBHelper.noteTitleColumn] ?? "",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 10),
              Text(
                DateFormat('MMMM d, y')
                    .format(
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(
                          widget.note[DBHelper.noteUpdatedAtColumn] ?? "0",
                        ),
                      ),
                    )
                    .toString(),
                style: Theme.of(context).textTheme.labelSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              SizedBox(height: 10),
              Text(
                widget.note[DBHelper.noteDescColumn] ?? "",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
