import 'dart:math';

import 'package:db_example/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/db_helper.dart';
import '../widgets/app_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;
  List<Map<String, dynamic>> mNotes = [];
  List<Color> colors = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper.getInstance();
    getAllNotes();
  }

  getAllNotes() async {
    mNotes = await dbHelper!.fetchAllNotes();
    if (mNotes.isNotEmpty) {
      generateColors();
    }
    setState(() {});
  }

  generateColors() {
    colors = List.generate(
      mNotes.length,
      (index) => Color.fromARGB(
        255,
        Random().nextInt(256),
        Random().nextInt(256),
        Random().nextInt(256),
      ),
    );
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
        child:
            mNotes.isNotEmpty
                ? GridView.builder(
                  itemCount: mNotes.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.noteDetailsScreen,
                          arguments: mNotes[index],
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colors[index],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mNotes[index][DBHelper.noteTitleColumn] ?? "",
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
                                        mNotes[index][DBHelper
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
                )
                : Center(
                  child: Text(
                    "No Notes yet!!",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
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
                if (title.trim().isEmpty && desc.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please enter values."),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                await dbHelper!.addNote(title: title.trim(), desc: desc.trim());
                await getAllNotes();
              },
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
