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
import 'package:homeslice/view_profile.dart';
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
    Future<Map> _matches = getMatches(user.uid);

    return Scaffold(
      // app body
      body: new Padding(
        padding: EdgeInsets.fromLTRB(50, 30, 50, 30),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<List<dynamic>>(
                future: Future.wait([_conversations, _matches]),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  print("entering switch");
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      print("connection done");
                      if (snapshot.data!.isNotEmpty) {
                        print("data received, not empty");
                        print(snapshot.data.toString());
                        List conversations = snapshot.data![0];
                        print("test: " + conversations.length.toString());
                        Map matches = snapshot.data![1];
                        matches.removeWhere((key, value) =>
                            conversations.map((c) => c.id).contains(key));

                        return ListView(
                          shrinkWrap: true,
                          children: [
                            ExpansionTile(
                              initiallyExpanded: true,
                              title: Text("New Matches"),
                              children: matches.entries
                                  .map((m) => SizedBox(
                                        height: 100,
                                        child: new Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 8),
                                          child: MatchTile(
                                            name: m.value["full_name"],
                                            imageUrl: m.value["image"],
                                            id: m.key,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            ExpansionTile(
                              initiallyExpanded: true,
                              title: Text("Conversations"),
                              children: conversations
                                  .map((c) => SizedBox(
                                        height: 100,
                                        child: new Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 8),
                                          child: c,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                        );
                      } else {
                        print("else");
                        return Center(
                          child: Text("No Active Conversations"),
                        );
                      }

                    default:
                      return Center(child: CircularProgressIndicator());
                  }
                }),
          ],
        ),
      ),
    );
  }
}

// widget used for each individual convo
class ConversationTile extends StatefulWidget {
  final String name;
  final String id;
  final String messageText;
  final String imageUrl;
  final String time;
  final String convoID; // pass in conversation ID here

  ConversationTile(
      {required this.name,
      required this.id,
      required this.messageText,
      required this.imageUrl,
      required this.time,
      required this.convoID});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<ConversationTile> {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);

    return GestureDetector(
        onTap: () async {
          var messagesFromDatabase =
              []; // empty list that will hold Messages objects to be passed into the converation widget
          QuerySnapshot databaseMessages = await getMessages(widget.convoID);
          print("\n\n\nconvo ID : " + widget.convoID);
          databaseMessages.docs.forEach((res) {
            print("\nin loop");
            // loops through all the messages and creates the message widgets
            print("message : " + res.get("Text".toString()));
            String messageType = "receiver";
            if (res.get("Sender") == user!.uid) {
              // check who is sending the message
              messageType = "sender";
            } else {
              messageType = "receiver";
            }
            messagesFromDatabase.add(Message(
                messageText: res.get("Text").toString(),
                time: res.get("Timestamp").toString(),
                type: messageType));
          });

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Conversation(
              name: widget.name,
              messageText: widget.messageText,
              imageUrl: widget.imageUrl,
              time: widget.time,
              convoID: widget.convoID,
              messages: messagesFromDatabase,
            );
          }));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[500]
                : Colors.grey[900],
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
                          height: 15,
                        ),
                        Row(
                          children: [
                            Builder(builder: (context) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width / 7,
                                child: Text(
                                  widget.messageText,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.grey[700]
                                          : Colors.grey[300]),
                                ),
                              );
                            }),
                            Text(
                              "  ·  " +
                                  widget.time.split(' ')[1] +
                                  ' ' +
                                  widget.time.split(' ')[2],
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey[700]
                                      : Colors.grey[300]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // popup menu
              PopupMenuButton(
                  itemBuilder: (context) => [
                        // profile option
                        PopupMenuItem(
                          onTap: () {
                            // show profile
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ViewProfile(user: user);
                            }));
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

                        PopupMenuItem(
                          onTap: () {
                            unmatch(user!.uid,
                                widget.id); // remove user from matches
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

// widget used for new matches
class MatchTile extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String id;

  MatchTile({required this.name, required this.imageUrl, required this.id});

  @override
  _MatchState createState() => _MatchState();
}

class _MatchState extends State<MatchTile> {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);

    return GestureDetector(
        onTap: () async {
          // unmatch(user!.uid, widget.id); // remove user from matches

          // start a new conversation
          DocumentReference convoDoc =
              await addConversation(user!.uid, widget.id);

          print("\n\n\nconvo ID : " + convoDoc.id);

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Conversation(
              name: widget.name,
              messageText: "",
              imageUrl: widget.imageUrl,
              time: "",
              convoID: convoDoc.id,
              messages: [],
            );
          }));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[500]
                : Colors.grey[900],
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
                          height: 15,
                        ),
                        Text(
                          "Tap to start talking!",
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey[700]
                                    : Colors.grey[300],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // popup menu
              PopupMenuButton(
                  itemBuilder: (context) => [
                        // profile option
                        PopupMenuItem(
                          onTap: () {
                            print("View profile trigger");
                            // show profile
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewProfile(user: user)),
                            );
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

                        PopupMenuItem(
                          onTap: () {
                            unmatch(user!.uid,
                                widget.id); // remove user from matches
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
