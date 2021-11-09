/* set up profile
*  Last updated 2021-11-02 by Natasha
*
* Includes:
* editing user profile details
* who are you page
* search criteria
* preferences
*/
import 'package:flutter/material.dart';

class Setup extends StatefulWidget {
  const Setup({Key? key}) : super(key: key);

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  //Stepper index
  int _index = 0;
  // User's preferred name
  String _prefName = '';
  // User's preferred pronouns
  String? _dropdownValue = 'Select Pronouns';
  //User's major
  String _major = 'N/A';
  //User's year of study
  double _year = 1;
  //User profile blurb
  String _blurb = '';
  //Desired number of housemates
  RangeValues _mates = const RangeValues(2, 6);
  //User rent price range
  RangeValues _rent = const RangeValues(700, 1000);
  //User coed preference
  bool _coed = true;
  //User campus distance
  RangeValues _mins_to_campus = RangeValues(10, 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Set Up')),
      body: Stepper(
          currentStep: _index,
          onStepCancel: () {
            if (_index > 0) {
              setState(() {
                _index -= 1;
              });
            }
          },
          onStepContinue: () {
            if (_index <= 0) {
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
                    onChanged: (String? newValue) {
                      setState(() {
                        _dropdownValue = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: '1',
                        child: Text('he/him'),
                      ),
                      DropdownMenuItem(
                        value: '2',
                        child: Text('she/her'),
                      ),
                      DropdownMenuItem(
                        value: '3',
                        child: Text('they/them'),
                      ),
                    ],
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
                      label: _year.toString(),
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
                  RangeSlider(
                      values: _mates,
                      min: 0,
                      max: 6,
                      divisions: 6,
                      labels: RangeLabels(
                          _mates.start.toString(), _mates.end.toString()),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _mates = values;
                        });
                      }),
                  // Rent Range Selection
                  const Text('Individual Monthly Rent'),
                  RangeSlider(
                      values: _rent,
                      min: 0,
                      max: 1200,
                      divisions: null,
                      labels: RangeLabels(_rent.start.round().toString(),
                          _rent.end.round().toString()),
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
                      values: _mins_to_campus,
                      min: 5,
                      max: 30,
                      divisions: 5,
                      labels: RangeLabels(
                          _mins_to_campus.start.toString() + 'mins',
                          _mins_to_campus.end.toString() + 'mins'),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _mins_to_campus = values;
                        });
                      }),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Start Searching'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Complete Profile'),
                  ),
                ],
              ),
            ),
            // Step 3:
            Step(
              title: const Text('Location'),
              content: Column(),
            ),
            //Step 4
            Step(
              title: const Text('Ground Rules'),
              content: Column(),
            ),
          ]),
    );
  }
}
