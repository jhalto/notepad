import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notepad/add_note.dart';

class GeminiAi extends StatefulWidget {
  const GeminiAi({Key? key}) : super(key: key);

  @override
  State<GeminiAi> createState() => _GeminiAiState();
}

class _GeminiAiState extends State<GeminiAi> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gemini Chat"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: ()async{
           final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddNote(),));
           Navigator.pop(context,result);
          }, icon: Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isUser ? Colors.blue : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.imageBytes != null)
                          Image.memory(
                            message.imageBytes!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        SizedBox(height: 8),
                        SelectableText(
                          message.text,
                          style: TextStyle(
                            color: message.isUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _sendMediaMessage,
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_textController.text, null),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text, Uint8List? imageBytes) {
    if (text.isNotEmpty || imageBytes != null) {
      final userMessage = ChatMessage(
        text: text,
        isUser: true,
        imageBytes: imageBytes,
      );
      setState(() {
        messages.insert(0, userMessage);
      });
      _textController.clear();
      _scrollToBottom();

      List<Uint8List>? images;
      if (imageBytes != null) {
        images = [imageBytes];
      }

      gemini.streamGenerateContent(text, images: images).listen(
            (event) {
          ChatMessage botMessage;
          if (messages.isNotEmpty && !messages.first.isUser) {
            botMessage = messages.first;
          } else {
            botMessage = ChatMessage(text: "", isUser: false);
            setState(() {
              messages.insert(0, botMessage);
            });
          }

          setState(() {
            botMessage.text += event.content?.parts?.firstOrNull?.text ?? "";
          });
          _scrollToBottom();
        },
        onError: (error) {
          print("Error: $error");
          setState(() {
            messages.insert(0, ChatMessage(text: "Error: $error", isUser: false));
          });
        },
        onDone: () {
          print("Stream finished");
        },
      );
    }
  }

  void _sendMediaMessage() async {
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      Uint8List bytes;
      if (kIsWeb) {
        bytes = await file.readAsBytes();
      } else {
        bytes = await File(file.path).readAsBytes();
      }
      _sendMessage("Extract the text", bytes);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}

class ChatMessage {
  String text;
  final bool isUser;
  final Uint8List? imageBytes;

  ChatMessage({required this.text, required this.isUser, this.imageBytes});
}