import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homeslice/custom_icons.dart';
import 'dart:math';

import 'package:homeslice/database.dart';
import 'package:homeslice/profile_card.dart';
import 'package:homeslice/settings.dart';
import 'package:homeslice/themes.dart';
import 'package:provider/provider.dart';

enum IconState { like, dislike, none }

class HomeSwipe extends StatefulWidget {
  const HomeSwipe({Key? key}) : super(key: key);

  @override
  State<HomeSwipe> createState() => _HomeSwipeState();
}

class _HomeSwipeState extends State<HomeSwipe> {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    Future<Map> _users = getUsers(user?.uid);

    return FutureBuilder<Map>(
      future: _users,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return CardStack(users: Map.from(snapshot.data!));
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class CardStack extends StatefulWidget {
  final Map users;

  const CardStack({Key? key, required this.users}) : super(key: key);

  @override
  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  double _opacity = 0;
  IconState _iconState = IconState.none;
  double? _iconAlignment;

  @override
  Widget build(BuildContext context) {
    _iconAlignment = () {
      switch (_iconState) {
        case IconState.like:
          return null;
        case IconState.dislike:
          return 0.0;
        default:
          return _iconAlignment;
      }
    }();

    return Stack(
      children: [
        Positioned(
          right: _iconAlignment,
          child: IgnorePointer(
            child: AnimatedOpacity(
              onEnd: () {
                setState(() {
                  _iconState = IconState.none;
                });
              },
              opacity: _opacity,
              duration: Duration(milliseconds: 100),
              child: Icon(
                () {
                  switch (_iconState) {
                    case IconState.like:
                      return Icons.check_circle;
                    case IconState.dislike:
                      return Icons.not_interested;
                    default:
                      return null;
                  }
                }(),
                size: 512,
              ),
            ),
          ),
        ),
        ...buildCards(widget.users),
        Center(child: Text("You've swiped through everyone! Come back later!")),
      ].reversed.toList(),
    );
  }

  List<Widget> buildCards(Map users) {
    return users.isNotEmpty
        ? [
            ProfileCard(
                user: users.entries.first,
                front: true,
                nextCard: _nextCard,
                onSwipe: (angle) {
                  setState(() {
                    if (angle > 5)
                      _iconState = IconState.like;
                    else if (angle < -5)
                      _iconState = IconState.dislike;
                    else
                      _iconState = IconState.none;

                    _opacity = angle.abs() > 5 ? 0.5 : 0.0;
                  });
                }),
            ...users.entries
                .map((e) => ProfileCard(user: e, nextCard: _nextCard))
                .toList()
                .sublist(1)
          ]
        : [];
    // return users.isNotEmpty
    //     ? [
    //         buildFrontCard(users.entries.first),
    //         ...users.entries.map((e) => buildCard(e)).toList().sublist(1)
    //       ]
    //     : [];
  }

  void _nextCard(user) async {
    if (widget.users.isEmpty) return;

    setState(() {
      widget.users.remove(user.key);
      _opacity = 0;
    });
  }
}
