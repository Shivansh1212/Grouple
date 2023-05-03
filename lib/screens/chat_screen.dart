import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat_flutter/components/message_tile.dart';
import 'package:flashchat_flutter/screens/group_info.dart';
import 'package:flashchat_flutter/service/database_service.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatScreen(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot>? chats;
  String admin = '';
  String finalmessage = '';
  bool sendToCurrentUser = true;
  TextEditingController msgController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  @override
  void dispose() {
    msgController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  getChatandAdmin() {
    DataBaseService().getChats(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
    DataBaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(widget.groupName),
          backgroundColor: Colors.black87,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return GroupInfo(
                        groupId: widget.groupId,
                        groupName: widget.groupName,
                        adminName: admin,
                        userName: widget.userName,
                      );
                    },
                  ),
                );
              },
              icon: const Icon(Icons.info),
            )
          ],
        ),
        body: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[700],
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: msgController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "send a message",
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 16),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            finalmessage = msgController.text;
                          });
                          sendMessage();
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }

  chatMessages() {
    return Container(
      margin: const EdgeInsets.only(bottom: 70),
      child: StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (scrollController.hasClients) {
                scrollController
                    .jumpTo(scrollController.position.maxScrollExtent);
              }
            });
            return ListView.builder(
              controller: scrollController,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return MessageTile(
                    time: DateTime.fromMillisecondsSinceEpoch(snapshot.data.docs[index]['time']),
                    message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    sendByMe:
                        widget.userName == snapshot.data.docs[index]['sender']);
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  sendMessage() {
    if (msgController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": msgController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      DataBaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        msgController.clear();
      });
    }
  }
}
