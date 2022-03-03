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

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    // User
    User? user = Provider.of<User?>(context);
    String? profileImg = user!.photoURL;
    String myName = user.displayName.toString();

    return Scaffold(
      body: Column(
        children: [
          //profile image or little portrait icon
          (profileImg != null)
              ? Image.network(
                  profileImg,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                )
              : Icon(Icons.portrait),

          //user's name
          Text(myName),

          //Edit Profile Info - goes to setup
          ElevatedButton(
            onPressed: () {
              setState(() {
                Navigator.pushNamed(context, '/setup');
              });
            },
            child: const Text('Edit Profile Info'),
          ),

          //Edit Account Details - goes to Settings
          ElevatedButton(
            onPressed: () {
              setState(() {
                Navigator.pushNamed(context, '/setup');
              });
            },
            child: const Text('Edit Account Details'),
          ),
        ],
      ),
    );
  }
}

//Widget 
