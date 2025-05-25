import 'package:flutter/material.dart';

import '../widgets/app_button.dart';

class NoteAddUpdateScreen extends StatefulWidget {
  const NoteAddUpdateScreen({
    super.key,
    required this.isAdding,
    required this.onSave,
    this.oldTitle,
    this.oldDesc,
  });

  final bool isAdding;
  final Function(String title, String desc) onSave;
  final String? oldTitle;
  final String? oldDesc;

  @override
  State<NoteAddUpdateScreen> createState() => _NoteAddUpdateScreenState();
}

class _NoteAddUpdateScreenState extends State<NoteAddUpdateScreen> {
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
            text: "Save",
            onPressed: () async {
              if (MediaQuery.of(context).viewInsets.bottom > 0) {
                FocusScope.of(context).unfocus();
              }
              await widget.onSave(title.text, desc.text);
              Navigator.of(context).pop();
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: title,
                style: Theme.of(context).textTheme.displayLarge,
                decoration: InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none,
                  counterText: "",
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 10,
                maxLength: 500,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: desc,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Type something...",
                  border: InputBorder.none,
                  counterText: "",
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 50,
                maxLength: 5000,
              ),
            ],
          ),
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
