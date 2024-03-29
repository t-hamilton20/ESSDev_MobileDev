// individual conversation class

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'chat_database.dart';

class Conversation extends StatefulWidget {
  final String name;
  final String messageText;
  final String imageUrl;
  final String time;
  final String convoID;
  final List messages;

  Conversation(
      {required this.name,
      required this.messageText,
      required this.imageUrl,
      required this.time,
      required this.convoID,
      required this.messages});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final newMessageController =
      TextEditingController(); // controller for the new message text input
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);

    return Scaffold(
      // Top app bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                ),

                // Image of profile pic
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.imageUrl),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 15,
                ),

                // Container used to display name
                Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(children: [
        // Messages
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: new ListView.builder(
              itemCount: widget.messages.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return new Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                  child: widget.messages[index],
                );
              },
            ),
          ),
        ),

        // Input messages
        Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      // Input text field
                      child: TextField(
                        controller: newMessageController,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 6,
                        cursorColor: Theme.of(context).hintColor,
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      // attach a file button
                      // child: FloatingActionButton(
                      //   mini: true,
                      //   onPressed: () {},
                      //   child: Icon(
                      //     Icons.attach_file,
                      //     color: Colors.white,
                      //     size: 15,
                      //   ),
                      //   backgroundColor: Theme.of(context).primaryColor,
                      //   elevation: 0,
                      // ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      // send a message button
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: () async {
                          if (newMessageController.text.isNotEmpty) {
                            DateTime date = new DateTime.now();
                            DateFormat df = DateFormat.yMd().add_jm();
                            print("timestamp" + df.format(date));

                            // add new message
                            sendMessage(
                                newMessageController.text,
                                df.format(date),
                                user!.uid,
                                date.millisecondsSinceEpoch,
                                false,
                                widget.convoID);

                            widget.messages.add(new Message(
                                messageText: newMessageController.text,
                                time: df.format(date),
                                type: "sender"));

                            newMessageController.clear();

                            setState(() {});
                          }
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 15,
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ]),
    );
  }
}

// Message class for each individual message
class Message extends StatefulWidget {
  final String messageText;
  final String time;
  final String type; // sender or receiver

  Message({required this.messageText, required this.time, required this.type});

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  bool displayTime = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          displayTime = !displayTime;
        });
      },
      child: Align(
        alignment: (widget.type ==
                "receiver" // if type is receiver alignment goes in top left
            ? Alignment.topLeft
            : Alignment.topRight),
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Column(
            children: [
              // container around message
              Align(
                alignment: (widget.type ==
                        "receiver" // if type is receiver alignment goes in top left
                    ? Alignment.topLeft
                    : Alignment.topRight),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: (widget.type ==
                            "receiver" // if type is receiver colour is light grey
                        ? (Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[400]
                            : Colors.grey[700])
                        : (Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[600]
                            : Colors.grey[900])),
                  ),
                  padding: EdgeInsets.all(16),
                  // actual message text
                  child: Text(
                    widget.messageText,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              // used to display time
              Visibility(
                visible: displayTime,
                child: Align(
                  alignment: (widget.type ==
                          "receiver" // if type is receiver alignment goes in top left
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget.time,
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
