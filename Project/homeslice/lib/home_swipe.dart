import 'package:flutter/material.dart';
import 'package:homeslice/custom_icons.dart';
import 'dart:math';

import 'package:homeslice/database.dart';

enum CardActions { like, dislike }

class HomeSwipe extends StatefulWidget {
  const HomeSwipe({Key? key}) : super(key: key);

  @override
  State<HomeSwipe> createState() => _HomeSwipeState();
}

class _HomeSwipeState extends State<HomeSwipe> {
  Future<Map> _users = getUsers("ER8wp6q1krN0pCBaWhbG");

  @override
  Widget build(BuildContext context) {
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
  Offset _position = Offset.zero;
  int _duration = 0;
  double _angle = 0;
  Size _screenSize = Size.zero;

  //TODO: Add swipe up to see profile

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(20),
      child: Stack(
        children: [
          ...buildCards(widget.users),
          Center(child: Text("Swiper gone swiping!")),
        ].reversed.toList(),
      ),
    );
  }

  Widget buildFrontCard(user) {
    return LayoutBuilder(builder: (context, constraints) {
      Offset center = constraints.biggest.center(Offset.zero);

      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: PageView(
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
                child: buildCard(user),
              ),
              onPanStart: (details) {
                setState(() {
                  _duration = 0;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _position += details.delta;
                  _angle = (_position.dx / _screenSize.width) * 45;
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _duration = 300;

                  switch (getAction()) {
                    case CardActions.like:
                      likeUser("ER8wp6q1krN0pCBaWhbG", user.key);
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
              },
            ),
            buildInfoSheet(user)
          ],
        ),
      );
    });
  }

  Widget buildCard(user) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://via.placeholder.com/500x1000?text=" +
                user.value['full_name']),
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
                                  border: Border.all(color: Colors.white)),
                              child: Icon(Icons.wc)),
                          SizedBox(width: 8)
                        ]
                      : []),
                  Container(
                    padding: EdgeInsets.fromLTRB(2, 2, 6, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.white)),
                    child: Row(
                      children: [
                        Icon(Icons.home_outlined),
                        Text(user.value['minHousemates'].toString() +
                            "-" +
                            user.value['maxHousemates'].toString())
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.fromLTRB(2, 2, 6, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.white)),
                    child: Row(
                      children: [
                        Icon(Icons.attach_money),
                        Text(user.value['minPrice'].toString() +
                            "-" +
                            user.value['maxPrice'].toString())
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: double.infinity,
                  child: Icon(Icons.expand_less),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildCards(Map users) {
    return users.isNotEmpty
        ? [
            buildFrontCard(users.entries.first),
            ...users.entries.map((e) => buildCard(e)).toList().sublist(1)
          ]
        : [];
  }

  CardActions? getAction() {
    int delta = 100;

    if (_position.dx >= delta) {
      return CardActions.like;
    } else if (_position.dx <= -delta) {
      return CardActions.dislike;
    }
  }

  void _nextCard(user) async {
    if (widget.users.isEmpty) return;

    await Future.delayed(Duration(milliseconds: 200));
    setState(() {
      widget.users.remove(user.key);
      _duration = 0;
      _position = Offset.zero;
      _angle = 0;
    });
  }

  Widget buildInfoSheet(user) {
    return Container(
      color: Colors.grey,
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
                "he/him",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          Text(
            "1st year, Engineering",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "\"Reprehenderit Lorem magna laborum esse pariatur laboris nisi proident. Cupidatat labore tempor aute ea aliqua in dolor cillum nulla incididunt qui dolor. Eu ex id sunt laboris dolor laboris cupidatat cupidatat officia sunt proident ullamco anim anim.\"",
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
                    border: Border.all(color: Colors.white)),
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
                    border: Border.all(color: Colors.white)),
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
                    border: Border.all(color: Colors.white)),
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
                    border: Border.all(color: Colors.white)),
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
                    border: Border.all(color: Colors.white)),
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
                    border: Border.all(color: Colors.white)),
                child: FittedBox(
                    child: user.value['preferences']['pets']
                        ? Icon(Icons.pets)
                        : _crossedOutIcon(Icon(Icons.pets))),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                child: FittedBox(
                    child: user.value['preferences']['hosting']
                        ? Icon(Icons.celebration)
                        : _crossedOutIcon(Icon(Icons.celebration))),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                child: FittedBox(
                    child: user.value['preferences']['sharingMeals']
                        ? Icon(Icons.local_dining)
                        : _crossedOutIcon(Icon(Icons.local_dining))),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                child: FittedBox(
                    child: user.value['preferences']['nearWest']
                        ? CustomIcon(CustomIcons.west_campus)
                        : _crossedOutIcon(CustomIcon(CustomIcons.west_campus))),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                child: FittedBox(
                    child: user.value['preferences']['northOfPrincess']
                        ? CustomIcon(CustomIcons.north_of_princess)
                        : _crossedOutIcon(
                            CustomIcon(CustomIcons.north_of_princess))),
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
}
