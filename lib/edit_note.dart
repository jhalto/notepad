import 'package:flutter/material.dart';
import 'package:notepad/db_helper.dart';
import 'package:notepad/note.dart';


class EditNote extends StatefulWidget {
  Note? note;
  EditNote({super.key,required this.note});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController? editTitle;
  TextEditingController? editNote;
  @override
  void initState() {
    editTitle = TextEditingController(text: widget.note!.title);
    editNote = TextEditingController(text: widget.note!.note);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Title:"),
              Container(
                child: TextField(
                  controller: editTitle,
                  maxLines: null,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text("Notes:"),
              SizedBox(height: 20),
              SingleChildScrollView(
                child: Container(
                  child: TextField(
                    controller: editNote,
                    maxLines: 5,
                  ),
                ),
              ),
              SizedBox(height: 50,),
              MaterialButton(onPressed: ()async{
                await DbHelper().updateNote(Note(note: editNote!.text,title: editTitle!.text,id: widget.note!.id));

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
