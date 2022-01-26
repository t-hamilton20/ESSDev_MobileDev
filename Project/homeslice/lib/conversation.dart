// individual conversation class

import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'chat.dart';
import 'chat_database.dart';

class Conversation extends StatefulWidget {
  String name;
  String messageText;
  String imageUrl;
  String time;
  String convoID;
  var messages;
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
                            hintStyle: TextStyle(color: Colors.grey[200]),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      // attach a file button
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: () {},
                        child: Icon(
                          Icons.attach_file,
                          color: Colors.white,
                          size: 15,
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      // send a message button
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: () async {
                          if (newMessageController.text.isNotEmpty) {
                            DateTime date = new DateTime.now();

                            // add new message
                            sendMessage(
                                newMessageController.text,
                                date.day.toString() +
                                    "/" +
                                    date.month.toString() +
                                    "/" +
                                    date.year.toString(),
                                date.hour.toString() +
                                    ":" +
                                    date.minute.toString(),
                                currentUser,
                                false,
                                "4JITZIL3sHHcwVVT9EYa"); // replace convoID with actual convoID

                            widget.messages.add(new Message(
                                messageText: newMessageController.text,
                                time: date.hour.toString() +
                                    ":" +
                                    date.minute.toString(),
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
  String messageText;
  String time;
  String type; // sender or receiver
  bool displayTime;

  Message(
      {required this.messageText,
      required this.time,
      required this.type,
      this.displayTime = false});

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.displayTime = !widget.displayTime;
        setState(() {});
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
                        ? Colors.grey[700]
                        : Colors.grey[900]),
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
                visible: widget.displayTime,
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
