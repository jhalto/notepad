import 'package:flutter/material.dart';
import 'package:notepad/db_helper.dart';
import 'package:notepad/note.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Notes"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Title"),
              Container(
                child: TextField(
                  controller: titleController,
                  maxLines: null,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text("Notes"),
              SizedBox(height: 20),
              SingleChildScrollView(
                child: Container(
                  child: TextField(
                    controller: noteController,
                    maxLines: null,
                  ),
                ),
              ),
              SizedBox(height: 50,),
              MaterialButton(onPressed: ()async{
               await DbHelper().createNote(Note(note: noteController.text,title: titleController.text));
                Navigator.pop(context,true);
              },
              child: Center(child: Text("Save"),),color: Colors.black12,
              )
            ],
          ),
        ),
      ),
    );
  }
}
