import 'package:db_example/providers/notes_provider.dart';
import 'package:db_example/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';
import '../services/db_helper.dart';

class NoteDetailsScreen extends StatelessWidget {
  const NoteDetailsScreen({super.key, required this.index});

  final int index;

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
          Consumer<NotesProvider>(
            builder: (context, provider, __) {
              return AppButton(
                icon: Icons.edit,
                onPressed: () async {
                  Navigator.of(context).pushNamed(
                    AppRoutes.noteAddUpdate,
                    arguments: {
                      "isAdding": false,
                      "onSaveClick": (String title, String desc) async {
                        provider.onUpdateSave(
                          context,
                          index: index,
                          title: title,
                          desc: desc,
                        );
                      },
                      "oldTitle": provider.note[DBHelper.noteTitleColumn],
                      "oldDesc": provider.note[DBHelper.noteDescColumn],
                    },
                  );
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
          child: Consumer<NotesProvider>(
            builder: (context, provider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.note[DBHelper.noteTitleColumn] ?? "",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 10),
                  Text(
                    DateFormat('MMMM d, y')
                        .format(
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(
                              provider.note[DBHelper.noteUpdatedAtColumn] ??
                                  "0",
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
                    provider.note[DBHelper.noteDescColumn] ?? "",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
