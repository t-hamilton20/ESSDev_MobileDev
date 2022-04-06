import 'package:flutter/material.dart';
import 'package:homeslice/profile_card.dart';

class ViewProfile extends StatefulWidget {
  final user;

  const ViewProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileCard(
        user: widget.user,
        gestures: false,
        front: true,
      ),
    );
  }
}
