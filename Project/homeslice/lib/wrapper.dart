import 'package:flutter/material.dart';
import 'package:homeslice/home_swipe.dart';
import 'package:homeslice/settings.dart';

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
            child: Text("Chat"),
          ),
          Center(
            child: Settings(),
          ),
        ],
      ),
    );
  }
}
