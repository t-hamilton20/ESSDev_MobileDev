import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _multiplier = 1.0;
  int _index = 0;

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  List<Map<String, String>> ingredients = [];

  void _addIngredient() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Ingredient'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Ingredient Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Add'),
                onPressed: () {
                  setState(() {
                    Map<String, String> ingredient = {
                      'name': _nameController.text,
                      'amount': _amountController.text
                    };
                    ingredients.add(ingredient);
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        });
  }

  List<Widget> _buildIngredientList() {
    return ingredients
        .map((ingredient) => ListTile(
              title: Text(ingredient['name']!),
              trailing: Text(ingredient['amount']!),
            ))
        .toList();
  }

  List<Widget> _buildFinalIngredientList() {
    return ingredients
        .map((ingredient) => ListTile(
              title: Text(ingredient['name']!),
              trailing: Text((double.parse(ingredient['amount']!) * _multiplier)
                  .toStringAsFixed(2)),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Multiplier'),
      ),
      body: Stepper(
        currentStep: _index,
        controlsBuilder: (BuildContext context,
            {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
          return Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: onStepContinue,
                child: Text(_index == 2 ? 'Restart' : 'Continue'),
              ),
              TextButton(
                child: const Text('Back'),
                onPressed: onStepCancel,
              ),
            ],
          );
        },
        onStepContinue: _index == 2
            ? () {
                setState(() {
                  _index = 0;
                });
              }
            : () {
                setState(() {
                  _index++;
                });
              },
        onStepCancel: _index == 0
            ? null
            : () {
                setState(() {
                  _index--;
                });
              },
        onStepTapped: (int index) {
          setState(() {
            _index = index;
          });
        },
        steps: [
          Step(
            title: const Text('Initial Recipe'),
            content: ListView(
              shrinkWrap: true,
              children: [
                ..._buildIngredientList(),
                ElevatedButton(
                    onPressed: () {
                      _addIngredient();
                    },
                    child: const Icon(Icons.add))
              ],
            ),
          ),
          Step(
            title: const Text('Choose Multiplier'),
            content: Slider(
              value: _multiplier,
              min: 0,
              max: 10,
              divisions: 20,
              label: _multiplier.toString(),
              onChanged: (value) {
                setState(() {
                  _multiplier = value;
                });
              },
            ),
          ),
          Step(
            title: const Text('Final Recipe'),
            content: ListView(
              shrinkWrap: true,
              children: _buildFinalIngredientList(),
            ),
          ),
        ],
      ),
    );
  }
}
