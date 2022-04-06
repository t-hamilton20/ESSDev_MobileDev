import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homeslice/custom_icons.dart';
import 'package:homeslice/database.dart';
import 'package:provider/provider.dart';

enum CardActions { like, dislike }

class ProfileCard extends StatefulWidget {
  final bool front;
  final bool gestures;
  final MapEntry user;
  final void Function(dynamic)? nextCard;
  final void Function(double)? onSwipe;

  const ProfileCard(
      {Key? key,
      required this.user,
      this.nextCard,
      this.onSwipe,
      this.front = false,
      this.gestures = true})
      : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Offset _position = Offset.zero;
  int _duration = 0;
  double _angle = 0;
  Size _screenSize = Size.zero;

  User? currentUser;

  String ordinalNumber(int n) {
    if (n < 0) throw Exception('Invalid Number');

    switch (n % 10) {
      case 1:
        return '${n}st';
      case 2:
        return '${n}nd';
      case 3:
        return '${n}rd';
      default:
        return '${n}th';
    }
  }

  CardActions? getAction() {
    int delta = 100;

    if (_position.dx >= delta) {
      return CardActions.like;
    } else if (_position.dx <= -delta) {
      return CardActions.dislike;
    }
    return null;
  }

  Future _nextCard(user) async {
    await Future.delayed(Duration(milliseconds: 200));
    setState(() {
      _duration = 0;
      _position = Offset.zero;
      _angle = 0;
    });
    widget.nextCard!(user);
  }

  Widget buildFrontCard(user, {gestures = true}) {
    PageController _pageController = PageController();

    return LayoutBuilder(builder: (context, constraints) {
      Offset center = constraints.biggest.center(Offset.zero);

      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          children: [
            GestureDetector(
              child: AnimatedContainer(
                duration: Duration(milliseconds: _duration),
                transform: Matrix4.identity()
                  ..translate(center.dx, center.dy)
                  ..rotateZ(_angle * (pi / 180))
                  ..translate(-center.dx, -center.dy)
                  ..translate(_position.dx),
                child: buildCard(user,
                    onTap: () => _pageController.animateToPage(1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease)),
              ),
              onPanStart: (gestures
                  ? (details) {
                      setState(() {
                        _duration = 0;
                      });
                    }
                  : null),
              onPanUpdate: (gestures
                  ? (details) {
                      setState(() {
                        _position += details.delta;
                        _angle = (_position.dx / _screenSize.width) * 45;
                        widget.onSwipe!(_angle);
                      });
                    }
                  : null),
              onPanEnd: (gestures
                  ? (details) {
                      setState(() {
                        _duration = 300;

                        switch (getAction()) {
                          case CardActions.like:
                            likeUser(currentUser?.uid, user.key);
                            _position += Offset(2 * _screenSize.width, 0);
                            _angle = 20;
                            _nextCard(user);
                            break;
                          case CardActions.dislike:
                            _position -= Offset(2 * _screenSize.width, 0);
                            _angle = -20;
                            _nextCard(user);
                            break;
                          default:
                            _position = Offset.zero;
                            _angle = 0;
                        }
                      });
                    }
                  : null),
            ),
            buildInfoSheet(user)
          ],
        ),
      );
    });
  }

  Widget buildCard(user, {onTap}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(user.value['image']),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.value['full_name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...(user.value['coed']
                        ? [
                            Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white)),
                                child: Icon(
                                  Icons.wc,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                )),
                            SizedBox(width: 8)
                          ]
                        : []),
                    Container(
                      padding: EdgeInsets.fromLTRB(2, 2, 6, 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.home_outlined,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          Text(
                            user.value['minHousemates'].toString() +
                                "-" +
                                user.value['maxHousemates'].toString(),
                            style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.fromLTRB(2, 2, 6, 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          Text(
                            user.value['minPrice'].toString() +
                                "-" +
                                user.value['maxPrice'].toString(),
                            style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: double.infinity,
                      child: Icon(
                        Icons.expand_less,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoSheet(user) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                user.value['full_name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(width: 8),
              Text(
                user.value['pronouns'],
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          Text(
            "${ordinalNumber(user.value['year'])} year, ${user.value['major']}",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "\"${user.value['blurb']}\"",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          GridView.count(
            primary: false,
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
                child: Column(
                  children: [
                    Expanded(
                      child: FittedBox(child: Icon(Icons.house_outlined)),
                    ),
                    Text(
                      user.value['minHousemates'].toString() +
                          "-" +
                          user.value['maxHousemates'].toString(),
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
                child: Column(
                  children: [
                    Expanded(
                      child: FittedBox(child: Icon(Icons.attach_money)),
                    ),
                    Text(
                      user.value['minPrice'].toString() +
                          "-" +
                          (user.value['maxPrice'] >= 1000
                              ? (user.value['maxPrice'] / 1000)
                                      .toStringAsFixed(1) +
                                  "k"
                              : user.value['maxPrice'].toString()),
                      style: TextStyle(fontSize: 13),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
                child: Column(
                  children: [
                    Expanded(
                      child: FittedBox(child: Icon(Icons.directions_walk)),
                    ),
                    Text(
                      user.value['minDist'].toString() +
                          "-" +
                          user.value['maxDist'].toString(),
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
                child: Column(
                  children: [
                    Expanded(
                      child: FittedBox(child: Icon(Icons.soap)),
                    ),
                    Text(
                      user.value['preferences']['tidiness'].toString(),
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
                child: Column(
                  children: [
                    Expanded(
                      child: FittedBox(child: Icon(Icons.nightlife)),
                    ),
                    Text(
                      user.value['preferences']['nightsOut'].toString(),
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
                child: FittedBox(
                    child: user.value['preferences']['pets']
                        ? Icon(Icons.pets)
                        : _crossedOutIcon(Icon(Icons.pets))),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
                child: FittedBox(
                    child: user.value['preferences']['hosting']
                        ? Icon(Icons.celebration)
                        : _crossedOutIcon(Icon(Icons.celebration))),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
                child: FittedBox(
                    child: user.value['preferences']['sharingMeals']
                        ? Icon(Icons.local_dining)
                        : _crossedOutIcon(Icon(Icons.local_dining))),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
                child: FittedBox(
                    child: user.value['preferences']['nearWest']
                        ? CustomIcon(
                            CustomIcons.west_campus,
                            color: Theme.of(context).iconTheme.color,
                          )
                        : _crossedOutIcon(CustomIcon(CustomIcons.west_campus,
                            color: Theme.of(context).iconTheme.color))),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
                child: FittedBox(
                    child: user.value['preferences']['northOfPrincess']
                        ? CustomIcon(
                            CustomIcons.north_of_princess,
                            color: Theme.of(context).iconTheme.color,
                          )
                        : _crossedOutIcon(CustomIcon(
                            CustomIcons.north_of_princess,
                            color: Theme.of(context).iconTheme.color))),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _crossedOutIcon(icon) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.not_interested, size: 40),
        Padding(
          padding: const EdgeInsets.all(10),
          child: icon,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    currentUser = Provider.of<User?>(context);

    if (widget.front) {
      return this.buildFrontCard(widget.user, gestures: widget.gestures);
    } else {
      return this.buildCard(widget.user);
    }
  }
}
