import 'package:flutter/material.dart';
import 'package:notepad/add_note.dart';
import 'package:notepad/db_helper.dart';
import 'package:notepad/edit_note.dart';
import 'package:notepad/gemini.dart';
import 'package:notepad/view_notes.dart';

import 'note.dart';

class Home extends StatefulWidget {
  Note? note;
  // const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(onPressed: ()async{
             final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => GeminiAi(),));
             if(result == true){
               setState(() {

               });
             }

            }, child: Text("Gemini"))
          ],
          backgroundColor: Colors.black,
          title: Text("Notes",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: FutureBuilder(future: DbHelper().readNotes(), builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot){
            if(!snapshot.hasData){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text("loading")
                  ],
                ),
              );
            }
            return snapshot.data!.isEmpty ? Center(child: Text("Data Nai")):
                GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  children: snapshot.data!.map((e) => GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewNotes(note: e),));
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Title: ${ e.title}"),
                          SizedBox(height: 10,),

                          Text("Note: ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(e.note
                          ,maxLines: 3,),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(onPressed: ()async{
                              final result= await Navigator.push(context, MaterialPageRoute(builder: (context) => EditNote(note: e,),));
                              if(result==true){
                                setState(() {

                                });
                              }
                              }, icon: Icon(Icons.edit)),
                              IconButton(onPressed: ()async{
                                await DbHelper().deleteNote(e.id!);
                                setState(() {

                                });
                              }, icon: Icon(Icons.delete)),
                            ],
                          )
                        ],
                      )

                    ),
                  ),).toList(),
                );
          }),
        ),
        floatingActionButton: FloatingActionButton(onPressed: ()async{
         final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddNote(),));
         if(result == true){
           setState(() {

           });
         }
        },child: Icon(Icons.add),),
      ),
    );
  }
}
