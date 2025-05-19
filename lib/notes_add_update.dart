import 'package:flutter/material.dart';

class NotesAddUpdate extends StatefulWidget {
  const NotesAddUpdate({
    super.key,
    required this.isAdding,
    required this.onAddUpdate,
    this.oldTitle,
    this.oldDesc,
  });

  final bool isAdding;
  final Function(String title, String desc) onAddUpdate;
  final String? oldTitle;
  final String? oldDesc;

  @override
  State<NotesAddUpdate> createState() => _NotesAddUpdateState();
}

class _NotesAddUpdateState extends State<NotesAddUpdate> {
  final TextEditingController title = TextEditingController();

  final TextEditingController desc = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!widget.isAdding) {
      title.text = widget.oldTitle ?? "";
      desc.text = widget.oldDesc ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isAdding ? "Add Note" : "Update Note",
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: title,
              decoration: InputDecoration(
                hintText: "Enter title",
                labelText: "Title",
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: desc,
              decoration: InputDecoration(
                hintText: "Enter description",
                labelText: "Description",
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () => widget.onAddUpdate(title.text, desc.text),
                  child: Text(widget.isAdding ? "Add" : "Update"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    title.dispose();
    desc.dispose();
    super.dispose();
  }
}
