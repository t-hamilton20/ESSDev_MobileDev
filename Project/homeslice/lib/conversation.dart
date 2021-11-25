import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  String name;
  String messageText;
  String imageUrl;
  String time;
  Conversation({
    required this.name,
    required this.messageText,
    required this.imageUrl,
    required this.time,
  });

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.imageUrl),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 15,
                ),
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
      body: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            child: Row(
              children: <Widget>[
                // GestureDetector(
                //   onTap: () {},
                //   child: Container(
                //     height: 30,
                //     width: 30,
                //     decoration: BoxDecoration(
                //       color: Colors.lightBlue,
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //     child: Icon(
                //       Icons.add,
                //       color: Colors.white,
                //       size: 20,
                //     ),
                //   ),
                // ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.grey[200]),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                FloatingActionButton(
                  mini: true,
                  onPressed: () {},
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 15,
                  ),
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  elevation: 0,
                ),
              ],
            ),
          )),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Theme.of(context).primaryColor,
    //     new Row(

    //     )
    //     ),
    // );
  }
}
