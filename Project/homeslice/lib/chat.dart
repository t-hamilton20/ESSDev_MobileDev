/* implementation of chat using Firebase
*  Last updated 2021-11-16 by Tom
*
* Includes:
* Unmatch_User
* Open_Chat
* Send_Message
* Recieve_Message
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'conversation.dart';
import 'chat_database.dart';
import 'database.dart';

class ConversationList extends StatefulWidget {
  ConversationList();

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    Future<List> _conversations = getConversationsForUser(user!.uid);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Homeslice"),
        backgroundColor: Theme.of(context).primaryColor,
      ),

      // app body
      body: new Padding(
        padding: EdgeInsets.fromLTRB(50, 30, 50, 30),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new SizedBox(
                height: 20,
              ),
              new SizedBox(
                height: 300,
                child: FutureBuilder<List<dynamic>>(
                    future: _conversations,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.data!.isNotEmpty) {
                        return snapshot.data![0][0];
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// widget used for each individual convo
class ConversationTile extends StatefulWidget {
  String name;
  String messageText;
  String imageUrl;
  String time;
  bool isMessageRead;
  bool tapFlag;
  String convoID; // pass in conversation ID here

  ConversationTile(
      {required this.name,
      required this.messageText,
      required this.imageUrl,
      required this.time,
      required this.isMessageRead,
      this.convoID = "DUMMY STRING", // CHANGE THIS
      this.tapFlag = false});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<ConversationTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          var messagesFromDatabase =
              []; // empty list that will hold Messages objects to be passed into the converation widget
          QuerySnapshot database_messages = await getMessages(
              "4JITZIL3sHHcwVVT9EYa"); // replace this with the line below
          //await getMessages(getConversation(currentUser, widget.name).toString()); // gets the messages for the given conversation

          database_messages.docs.forEach((res) {
            // loops through all the messages and creates the message widgets
            messagesFromDatabase.add(Message(
                messageText: res.get("message").toString(),
                time: res.get("time").toString(),
                type: "receiver"));
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Conversation(
              name: widget.name,
              messageText: widget.messageText,
              imageUrl: widget.imageUrl,
              time: widget.time,
              convoID: "4JITZIL3sHHcwVVT9EYa",
              messages: messagesFromDatabase,
              //convoID: getConversation(currentUser, widget.name).toString(),
            );
          }));

          widget.tapFlag = true;
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: (widget.tapFlag ? Colors.grey[500] : Colors.grey[900]),
          ),
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Row(
            // two different row widgets are used to ensure popup menu is aligned properly
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // profile pic
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  // container with text
                  Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.messageText,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[300],
                              fontWeight: widget.isMessageRead
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              // popup menu
              PopupMenuButton(
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {
                            // delete from conversations
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.delete),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Delete Conversation"),
                            ],
                          ),
                        ),

                        // profile option
                        PopupMenuItem(
                          onTap: () {
                            // show profile
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.person),
                              SizedBox(
                                width: 10,
                              ),
                              Text("View Profile"),
                            ],
                          ),
                        ),

                        // add to group option
                        PopupMenuItem(
                          onTap: () {
                            // invite to group
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.group),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Invite to Group"),
                            ],
                          ),
                        ),

                        PopupMenuItem(
                          onTap: () {
                            // unmatch user
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.block),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Unmatch User"),
                            ],
                          ),
                        ),
                      ]),
            ],
          ),
        ));
  }
}
