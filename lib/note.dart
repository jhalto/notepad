class Note{
  int? id;
  String? title;
  String note;
  Note({this.id, this.title, required this.note});
  factory Note.fromMap(Map<String,dynamic> s)=> Note(id: s['id'],title: s['title'],note: s['note']);
  Map<String,dynamic> toMap() => {'id':id,'title': title,'note': note};
}