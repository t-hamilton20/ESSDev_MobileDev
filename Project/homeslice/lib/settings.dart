/* navigate user to change account settings
*  Last updated YYYY-MM-DD by NAME
*
* Includes:
* Change_Email
* Change_Password
* Send_to_Setup
* Toggle_Theme
* Remove_Account
* Delete_Account
*/

import 'package:homeslice/profile_card.dart';
import 'package:homeslice/themes.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:homeslice/database.dart';
import 'package:homeslice/home_swipe.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:homeslice/custom_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class Profile extends HomeSwipe {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    // User
    User? user = Provider.of<User?>(context);
    Future<DocumentSnapshot> _doc = getUser(user?.uid);
    //Future<Map> _users = getUsers(user?.uid);

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: _doc,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Scaffold(
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pushNamed(context, '/options');
                  },
                  label: Text(
                    'Edit',
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white),
                  ),
                  icon: Icon(
                    Icons.settings,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                body: ProfileCard(
                  user: MapEntry(snapshot.data!.id, snapshot.data!.data()),
                  gestures: false,
                  front: true,
                ),
              );

            default:
              return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildCard(user, {gestures = true}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(user['image']),
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
                  user['full_name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...(user['coed']
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
                            user['minHousemates'].toString() +
                                "-" +
                                user['maxHousemates'].toString(),
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
                            user['minPrice'].toString() +
                                "-" +
                                user['maxPrice'].toString(),
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
                Padding(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFrontCard(user, {gestures = true}) {
    Offset _position = Offset.zero;
    int _duration = 0;
    double _angle = 0;
    Size _screenSize = Size.zero;
    IconState _iconState = IconState.none;
    double? _iconAlignment;

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
                        if (_angle > 5)
                          _iconState = IconState.like;
                        else if (_angle < -5)
                          _iconState = IconState.dislike;
                        else
                          _iconState = IconState.none;
                      });
                    }
                  : null),
              onPanEnd: (gestures
                  ? (details) {
                      setState(() {
                        _duration = 300;
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
                user['full_name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(width: 8),
              Text(
                user["pronouns"],
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          Text(
            "Year " + user["year"].toString() + ", " + user["major"],
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              user["blurb"],
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
                      user['minHousemates'].toString() +
                          "-" +
                          user['maxHousemates'].toString(),
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
                      user['minPrice'].toString() +
                          "-" +
                          (user['maxPrice'] >= 1000
                              ? (user['maxPrice'] / 1000).toStringAsFixed(1) +
                                  "k"
                              : user['maxPrice'].toString()),
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
                      user['minDist'].toString() +
                          "-" +
                          user['maxDist'].toString(),
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
                      user['preferences']['tidiness'].toString(),
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
                      user['preferences']['nightsOut'].toString(),
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
                    child: user['preferences']['pets']
                        ? Icon(Icons.pets)
                        : _crossedOutIcon(Icon(Icons.pets))),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                child: FittedBox(
                    child: user['preferences']['hosting']
                        ? Icon(Icons.celebration)
                        : _crossedOutIcon(Icon(Icons.celebration))),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                child: FittedBox(
                    child: user['preferences']['sharingMeals']
                        ? Icon(Icons.local_dining)
                        : _crossedOutIcon(Icon(Icons.local_dining))),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                child: FittedBox(
                    child: user['preferences']['nearWest']
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
                    border: Border.all(color: Colors.white)),
                child: FittedBox(
                    child: user['preferences']['northOfPrincess']
                        ? CustomIcon(CustomIcons.north_of_princess,
                            color: Theme.of(context).iconTheme.color)
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
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool night = false;
  bool hidden = false;
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    night = themeProvider.getThemeBool();

    // User
    User? user = Provider.of<User?>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("HomeSlice"),
        ),
        body: Column(
          children: [
            //Edit Profile Info - goes to Setup
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.pushNamed(context, '/setup');
                  });
                },
                child: const Text('Edit Profile Info'),
              ),
            ),
            //Edit Account Details - goes to Account Deets
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.pushNamed(context, '/deets');
                  });
                },
                child: const Text('Edit Account Details'),
              ),
            ),

            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text("Logout")),
            ),

            // Night Mode Toggle
            SwitchListTile(
                value: night,
                title: const Text("Night Mode"),
                onChanged: (value) {
                  ThemeProvider themeProvider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  themeProvider.swapTheme();
                  night = !themeProvider.getThemeBool();
                  setState(() {});
                }),

            // Unlist Account Toggle
            SwitchListTile(
                value: hidden,
                title: const Text("Unlist Account"),
                onChanged: (value) {
                  setState(() {
                    updateUser(
                      user?.uid,
                      hidden: value,
                    );
                  });
                }),
          ],
        ));
  }
}

class AccountDeets extends StatefulWidget {
  const AccountDeets({Key? key}) : super(key: key);

  @override
  _AccountDeetsState createState() => _AccountDeetsState();
}

class _AccountDeetsState extends State<AccountDeets> {
  String _email = '';
  String _newEmail = '';
  String _password = '';
  String _newPassword = '';
  String _newPassTwo = '';

  void getEmail(user) {
    _email = user["email"];
  }

  @override
  Widget build(BuildContext context) {
    // User
    User? user = Provider.of<User?>(context);
    Future<DocumentSnapshot> _doc = getUser(user!.uid);

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: _doc,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              getEmail(snapshot.data);
              return Scaffold(
                appBar: AppBar(
                  title: Text("HomeSlice"),
                ),
                body: Column(
                  children: [
                    // Current email linked to account
                    Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.all(8.0),
                      child: Text("Email: " + _email),
                    ),

                    // Change email button & popup
                    Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Change Email'),
                            actions: <Widget>[
                              TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Enter password",
                                  ),
                                  onChanged: (text) {
                                    _password = text;
                                  }),
                              TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Enter new email",
                                  ),
                                  onChanged: (text) {
                                    _newEmail = text;
                                  }),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_password != '' && _newEmail != '') {
                                    AuthCredential creds =
                                        EmailAuthProvider.credential(
                                            email: _email, password: _password);
                                    user
                                        .reauthenticateWithCredential(creds)
                                        .then((_) {
                                      user.updateEmail(_newEmail);
                                      updateUser(snapshot.data,
                                          email: _newEmail);
                                      Navigator.pop(context, 'OK');
                                    });
                                  }
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                        child: const Text('Change Email'),
                      ),
                    ),

                    // Change password button & popup
                    Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Change Password'),
                            actions: <Widget>[
                              TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Enter current password",
                                  ),
                                  onChanged: (text) {
                                    _password = text;
                                  }),
                              TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Enter new password",
                                  ),
                                  onChanged: (text) {
                                    _newPassword = text;
                                  }),
                              TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Confirm new password",
                                  ),
                                  onChanged: (text) {
                                    _newPassTwo = text;
                                  }),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_password != '' &&
                                      _newPassword != '' &&
                                      _newPassTwo != '') {
                                    AuthCredential creds =
                                        EmailAuthProvider.credential(
                                            email: _email, password: _password);
                                    user
                                        .reauthenticateWithCredential(creds)
                                        .then((_) {
                                      if (_newPassword == _newPassTwo) {
                                        user.updatePassword(_newPassword);
                                        Navigator.pop(context, 'OK');
                                      }
                                    });
                                  }
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                        child: const Text('Change Password'),
                      ),
                    ),

                    // Delete account button & popup
                    Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text(
                                'Are you sure you want to DELETE your account?'),
                            actions: <Widget>[
                              TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Enter current password",
                                  ),
                                  onChanged: (text) {
                                    _password = text;
                                  }),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_password != '') {
                                    AuthCredential creds =
                                        EmailAuthProvider.credential(
                                            email: _email, password: _password);
                                    user
                                        .reauthenticateWithCredential(creds)
                                        .then((_) {
                                      user.delete();
                                      Navigator.pop(context, 'OK');
                                    });
                                  }
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                        child: const Text('Delete Account'),
                      ),
                    )
                  ],
                ),
              );

            default:
              return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
