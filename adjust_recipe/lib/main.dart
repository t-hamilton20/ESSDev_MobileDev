import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Adjuster',
      theme: ThemeData(
        // This is the theme of the application.
        primarySwatch: Colors.green,
      ),
      home: RecipeAdjustPage(title: 'Adjust Page'),
    );
  }
}

class RecipeAdjustPage extends StatefulWidget {
  RecipeAdjustPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _RecipeAdjustPageState createState() => _RecipeAdjustPageState();
}

class _RecipeAdjustPageState extends State<RecipeAdjustPage> {
  String _ingredient = '';
  double _factor = 1;
  int _numEntered = 0;
  int _alternate = 0;
  var _itemList = List<String>.filled(5, '...');
  var _amountList = List.filled(5, 0);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.coffee)),
              Tab(icon: Icon(Icons.dinner_dining))
            ],
          ),
          title: Text('AppBar Title'),
        ),
        body: TabBarView(
          children: [
            Column(
              children: <Widget>[
                Text('Enter Recipe Information',
                    style: Theme.of(context).textTheme.button),
                // For user entry of igredient name
                TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ingredient Name',
                    ),
                    onSubmitted: (text) {
                      _doSomething(text);
                    }),
                // For user entry of ingredient amount
                TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ingredient Amount',
                    ),
                    onSubmitted: (amount) {
                      _doSomething(amount);
                    }),
                // List ingredients and amounts
                Text(_itemList[0] + ':' + _amountList[0].toString(),
                    style: Theme.of(context).textTheme.button),
                Text(_itemList[1] + ':' + _amountList[1].toString(),
                    style: Theme.of(context).textTheme.button),
                Text(_itemList[2] + ':' + _amountList[2].toString(),
                    style: Theme.of(context).textTheme.button),
                Text(_itemList[3] + ':' + _amountList[3].toString(),
                    style: Theme.of(context).textTheme.button),
                Text(_itemList[4] + ':' + _amountList[4].toString(),
                    style: Theme.of(context).textTheme.button),

                // Slider for recipe multiplication factor
                Slider(
                    value: _factor,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _factor.toString(),
                    onChanged: (double value) {
                      setState(() {
                        _factor = value;
                      });
                    })
              ],
            ),
            Icon(Icons.dinner_dining, size: 350),
          ],
        ),
      ),
    );
  }

  void _doSomething(String text) {
    setState(() {
      // When zero, edit ingredient name, other wise edit amount
      // Altername between updating name & amount until all 5 entered
      if (_alternate == 0) {
        _ingredient = text;
        if (_numEntered < 5) {
          _itemList[_numEntered] = _ingredient;
        }
        _alternate = 1;
      } else {
        if (_numEntered < 5) {
          _amountList[_numEntered] = int.parse(text);
        }
        _numEntered++;
        _alternate = 0;
      }
    });
  }
}
