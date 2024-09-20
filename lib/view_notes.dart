import 'package:flutter/material.dart';
import 'package:notepad/note.dart';

class ViewNotes extends StatelessWidget {
  Note note;
  ViewNotes({super.key,required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Notes",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Title : ${note.title}"),
                SizedBox(height: 50,),
                Text("Note: ${note.note}")
              ],
            ),
          ),
        ),
      ),

    );
  }
}
