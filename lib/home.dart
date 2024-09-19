import 'package:flutter/material.dart';
import 'package:notepad/add_note.dart';
import 'package:notepad/db_helper.dart';

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
          title: Text("Notes"),
          centerTitle: true,
        ),
        body: FutureBuilder(future: DbHelper().readNotes(), builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot){
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
                children: snapshot.data!.map((e) => Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Title: ${ e.title}"),
                      Text("Note: ${e.note}"),
                      Row(
                        children: [
                          IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
                          IconButton(onPressed: ()async{
                            await DbHelper().deleteNote(e.id!);
                            setState(() {

                            });
                          }, icon: Icon(Icons.delete)),
                        ],
                      )
                    ],
                  )

                ),).toList(),
              );
        }),
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
