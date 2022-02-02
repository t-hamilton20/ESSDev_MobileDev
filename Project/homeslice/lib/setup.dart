/* set up profile
*  Last updated 2021-11-02 by Natasha
*
* Includes:
* editing user profile details
* who are you page
* search criteria
* preferences
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:homeslice/database.dart';

class Setup extends StatefulWidget {
  const Setup({Key? key}) : super(key: key);

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  // Stepper index
  int _index = 0;

  // Mandatory Setup Variables

  // ABOUT ME
  // User's preferred name
  String _prefName = '';
  // User's preferred pronouns
  String? _dropdownValue = "they/them";
  // User's major
  String _major = 'N/A';
  // User's year of study
  double _year = 1;
  // User profile blurb
  String _blurb = '';
  // User profile image
  XFile? _profileImg;
  //File? file = null;

  // CRITERIA
  // Desired number of housemates
  RangeValues _mates = RangeValues(2, 6);
  // User rent price range
  RangeValues _rent = RangeValues(700, 1000);
  // User coed preference
  bool _coed = true;
  // User campus distance
  RangeValues _minsToCampus = RangeValues(10, 15);

  // PREFERENCES
  bool _north = true;
  bool _west = true;
  bool _pets = false;
  bool _host = false;
  bool _share = false;
  double _nightsOut = 2;
  double _tidiness = 3;
  List<String> _tidy = ["Very Low", "Low", "Medium", "High", "Very High"];

  @override
  Widget build(BuildContext context) {
    // User
    User? user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Set Up')),
      body: Stepper(
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Row(
              children: <Widget>[
                if (_index == 0) ...[
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: const Text('Next'),
                  ),
                ] else if (_index == 1) ...[
                  Column(children: [
                    ElevatedButton(
                      onPressed: () async {
                        DocumentSnapshot userDoc = await getUser(user?.uid);
                        setState(() {
                          if (!userDoc.exists) {
                            addUser(
                                    user?.uid,
                                    _prefName,
                                    user?.email,
                                    _dropdownValue,
                                    _major,
                                    _year,
                                    _blurb,
                                    _profileImg,
                                    _mates.start.round(),
                                    _mates.end.round(),
                                    _rent.start.round(),
                                    _rent.end.round(),
                                    _coed,
                                    _minsToCampus.start.round(),
                                    _minsToCampus.end.round(),
                                    tidiness: _tidiness,
                                    sharingMeals: _share,
                                    nearWest: _west,
                                    nightsOut: _nightsOut.round(),
                                    pets: _pets,
                                    northOfPrincess: _north,
                                    hosting: _host)
                                .then((_) =>
                                    Navigator.pushNamed(context, '/home'));
                          } else {
                            updateUser(
                              user?.uid,
                              name: _prefName,
                              email: user?.email,
                              pronouns: _dropdownValue,
                              major: _major,
                              year: _year,
                              blurb: _blurb,
                              image: _profileImg,
                              minHousemates: _mates.start.round(),
                              maxHousemates: _mates.end.round(),
                              minPrice: _rent.start.round(),
                              maxPrice: _rent.end.round(),
                              coed: _coed,
                              minDist: _minsToCampus.start.round(),
                              maxDist: _minsToCampus.end.round(),
                            ).then(
                                (_) => Navigator.pushNamed(context, '/home'));
                          }
                        });
                      },
                      child: const Text('Start Searching'),
                    ),
                    Row(children: [
                      ElevatedButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Back'),
                      ),
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: const Text('Next'),
                      ),
                    ]),
                  ]),
                ] else if (_index == 2) ...[
                  ElevatedButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      DocumentSnapshot userDoc = await getUser(user?.uid);
                      setState(() {
                        if (!userDoc.exists) {
                          addUser(
                            user?.uid,
                            _prefName,
                            user?.email,
                            _dropdownValue,
                            _major,
                            _year,
                            _blurb,
                            _profileImg,
                            _mates.start.round(),
                            _mates.end.round(),
                            _rent.start.round(),
                            _rent.end.round(),
                            _coed,
                            _minsToCampus.start.round(),
                            _minsToCampus.end.round(),
                          ).then((_) => Navigator.pushNamed(context, '/home'));
                        } else {
                          updateUser(user?.uid,
                                  name: _prefName,
                                  email: user?.email,
                                  pronouns: _dropdownValue,
                                  major: _major,
                                  year: _year,
                                  blurb: _blurb,
                                  image: _profileImg,
                                  minHousemates: _mates.start.round(),
                                  maxHousemates: _mates.end.round(),
                                  minPrice: _rent.start.round(),
                                  maxPrice: _rent.end.round(),
                                  coed: _coed,
                                  minDist: _minsToCampus.start.round(),
                                  maxDist: _minsToCampus.end.round(),
                                  tidiness: _tidiness,
                                  sharingMeals: _share,
                                  nearWest: _west,
                                  nightsOut: _nightsOut.round(),
                                  pets: _pets,
                                  northOfPrincess: _north,
                                  hosting: _host)
                              .then(
                                  (_) => Navigator.pushNamed(context, '/home'));
                        }
                      });
                    },
                    child: const Text('Finish'),
                  ),
                ]
              ],
            );
          },
          currentStep: _index,
          onStepCancel: () {
            if (_index > 0) {
              setState(() {
                _index -= 1;
              });
            }
          },
          onStepContinue: () {
            if (_index <= 2) {
              setState(() {
                _index += 1;
              });
            }
          },
          onStepTapped: (int index) {
            setState(() {
              _index = index;
            });
          },
          type: StepperType.vertical,
          steps: <Step>[
            // Step 1: About The User (profile)
            Step(
              title: const Text('Who are you?'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Preferred name entry
                  const Text('Preferred Name'),
                  TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Hello, my name is...',
                      ),
                      onChanged: (text) {
                        _prefName = text;
                      }),
                  // Pronoun entry
                  const Text('Pronouns'),
                  DropdownButton<String>(
                    value: _dropdownValue,
                    onChanged: (String? value) {
                      setState(() {
                        _dropdownValue = value;
                      });
                    },
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem(child: Text("he/him"), value: "he/him"),
                      DropdownMenuItem(
                          child: Text("she/her"), value: "she/her"),
                      DropdownMenuItem(
                          child: Text("they/them"), value: "they/them"),
                    ],
                    hint: Text('Select Pronouns'),
                  ),
                  // Major/Program entry
                  const Text('Major'),
                  TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'I\'m studying...',
                      ),
                      onChanged: (text) {
                        _major = text;
                      }),
                  // Year Entry
                  const Text('Current Year'),
                  Slider(
                      value: _year,
                      min: 1,
                      max: 7,
                      divisions: 6,
                      label: _year.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _year = value;
                        });
                      }),
                  // Profile Description entry
                  const Text('Describe yourself!'),
                  TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Profile Blurb',
                      ),
                      onChanged: (text) {
                        _blurb = text;
                      }),
                  // Add profile image
                  const Text("Select Profile Image"),
                  Row(
                    children: [
                      // Get image from camera
                      ElevatedButton(
                        onPressed: () async {
                          XFile? pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.camera,
                          );
                          setState(() {
                            _profileImg = pickedFile;
                          });
                        },
                        child: Icon(Icons.camera),
                      ),
                      // Get image from gallery
                      ElevatedButton(
                        onPressed: () async {
                          XFile? pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          setState(() {
                            _profileImg = pickedFile;
                          });
                        },
                        child: Icon(Icons.account_box),
                      ),
                    ],
                  ),
                  // Show Image
                  // Use Image.file and File(profileImg!.path) for mobile
                  (_profileImg != null)
                      ? Image.network(
                          _profileImg!.path,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        )
                      : Text("No Image Selected"),
                ],
              ),
            ),
            // Step 2: Search Criteria
            Step(
              title: const Text('What are you looking for?'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Housemate number
                  const Text('How many housemates?'),
                  Text(_mates.start.toString() +
                      ' - ' +
                      _mates.end.round().toString()),
                  RangeSlider(
                      values: _mates,
                      min: 1,
                      max: 6,
                      divisions: 5,
                      labels: RangeLabels(_mates.start.round().toString(),
                          _mates.end.round().toString()),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _mates = values;
                        });
                      }),
                  // Rent Range Selection
                  const Text('Individual Monthly Rent'),
                  Text(r'$' +
                      _rent.start.round().toString() +
                      r' - $' +
                      _rent.end.round().toString()),
                  RangeSlider(
                      values: _rent,
                      min: 500,
                      max: 1200,
                      divisions: null,
                      labels: RangeLabels(
                          (r'$' + _rent.start.round().toString()),
                          (r'$' + _rent.end.round().toString())),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _rent = values;
                        });
                      }),
                  // Coed?
                  const Text('Co-ed?'),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: _coed
                            ? null
                            : () {
                                setState(() {
                                  _coed = true;
                                });
                              },
                        child: const Text('YES'),
                      ),
                      ElevatedButton(
                        onPressed: !_coed
                            ? null
                            : () {
                                setState(() {
                                  _coed = false;
                                });
                              },
                        child: const Text('NO'),
                      ),
                    ],
                  ),
                  // Distance from campus
                  const Text('How far from campus?'),
                  RangeSlider(
                      values: _minsToCampus,
                      min: 5,
                      max: 30,
                      divisions: 5,
                      labels: RangeLabels(
                          _minsToCampus.start.toString() + 'mins',
                          _minsToCampus.end.toString() + 'mins'),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _minsToCampus = values;
                        });
                      }),
                ],
              ),
            ),
            // Step 3: Preferences
            Step(
              title: const Text('Preferences'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("What are you down with?"),
                  SwitchListTile(
                      value: _north,
                      title: const Text("North of Princess"),
                      onChanged: (value) {
                        setState(() {
                          _north = value;
                        });
                      }),
                  SwitchListTile(
                      value: _west,
                      title: const Text("West Campus"),
                      onChanged: (value) {
                        setState(() {
                          _west = value;
                        });
                      }),
                  SwitchListTile(
                      value: _host,
                      title: const Text("Hosting Parties"),
                      onChanged: (value) {
                        setState(() {
                          _host = value;
                        });
                      }),
                  SwitchListTile(
                      value: _pets,
                      title: const Text("Pets"),
                      onChanged: (value) {
                        setState(() {
                          _pets = value;
                        });
                      }),
                  SwitchListTile(
                      value: _share,
                      title: const Text("Shared Food"),
                      onChanged: (value) {
                        setState(() {
                          _share = value;
                        });
                      }),
                  const Text('Importance of Tidiness'),
                  Slider(
                      value: _tidiness,
                      min: 0,
                      max: 4,
                      divisions: 4,
                      label: _tidy[_tidiness.toInt()],
                      onChanged: (double value) {
                        setState(() {
                          _tidiness = value;
                        });
                      }),
                  const Text('Weekly Nights Out'),
                  Slider(
                      value: _nightsOut,
                      min: 0,
                      max: 7,
                      divisions: 7,
                      label: _nightsOut.toString(),
                      onChanged: (double value) {
                        setState(() {
                          _nightsOut = value;
                        });
                      }),
                ],
              ),
            ),
          ]),
    );
  }
}
