import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homeslice/chat_database.dart';
import 'package:homeslice/conversation.dart';
import 'package:homeslice/database.dart';
import 'package:homeslice/home_swipe.dart';
import 'package:provider/provider.dart';
import 'chat_database.dart';
import 'chat.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int _currentPage = 0;
  PageController _pageController = new PageController();

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("HomeSlice"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          _pageController.jumpToPage(index);
        },
        currentIndex: _currentPage,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.message_rounded), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          HomeSwipe(),
          Center(
            child: ConversationList(),
          ),
          Center(
            child: Profile(),
          ),
        ],
      ),
    );
  }
}
