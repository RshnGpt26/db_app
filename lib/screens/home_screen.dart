import 'package:db_example/providers/notes_provider.dart';
import 'package:db_example/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../services/db_helper.dart';
import '../widgets/app_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<NotesProvider>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          AppButton(
            icon: Icons.search,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Search functionality will be added soon!!"),
                ),
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Consumer<NotesProvider>(
          builder: (context, provider, __) {
            if (provider.mNotes.isEmpty) {
              return Center(
                child: Text(
                  "No Notes yet!!",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              );
            }
            return GridView.builder(
              itemCount: provider.mNotes.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    provider.note = provider.mNotes[index];
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.noteDetailsScreen, arguments: index);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: provider.colors[index],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.mNotes[index][DBHelper.noteTitleColumn] ??
                              "",
                          style: Theme.of(context).textTheme.displaySmall,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        Text(
                          DateFormat('MMMM d, y')
                              .format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(
                                    provider.mNotes[index][DBHelper
                                            .noteUpdatedAtColumn] ??
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
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          Navigator.of(context).pushNamed(
            AppRoutes.noteAddUpdate,
            arguments: {
              "isAdding": true,
              "onSaveClick": (String title, String desc) async {
                context.read<NotesProvider>().onAddSave(
                  context,
                  title: title,
                  desc: desc,
                );
              },
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
