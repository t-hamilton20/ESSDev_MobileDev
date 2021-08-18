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
        accentColor: Colors.lime,
        hoverColor: Colors.lime,
        sliderTheme: SliderThemeData(
          activeTickMarkColor: Colors.green,
          inactiveTickMarkColor: Colors.lime,
          inactiveTrackColor: Colors.lime,
          tickMarkShape: RoundSliderTickMarkShape(
            tickMarkRadius: 7,
          ),
          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        ),
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
  int _amount = 0;
  double _factor = 1;
  int _numEntered = 0;
  var _itemList = List<String>.filled(5, 'N/A');
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
          title: Text('Recipe Adjuster'),
        ),
        body: TabBarView(
          children: [
            Column(
              children: <Widget>[
                // Slider for recipe multiplication factor
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Select multiplyer:',
                      style: Theme.of(context).textTheme.headline4),
                ),
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
                    }),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Enter recipe details:',
                      style: Theme.of(context).textTheme.headline4),
                ),
                // For user entry of igredient name
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ingredient Name',
                      ),
                      onChanged: (text) {
                        _ingredient = text;
                      }),
                ),
                // For user entry of ingredient amount
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ingredient Amount',
                      ),
                      onChanged: (amount) {
                        _amount = int.parse(amount);
                      }),
                ),
                // For user to confirm adding ingredient
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: (_updateList),
                    child: const Text('Add Ingredient'),
                  ),
                ),
                // List ingredients and amounts
                //sized box ensures listview has box to go in
                SizedBox(
                  width: 250,
                  height: 250,
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: 5,
                      itemBuilder: (BuildContext contect, int index) {
                        return Container(
                          height: 50,
                          child: Text(
                              _itemList[index] +
                                  ': ' +
                                  _amountList[index].toString() +
                                  ' > ' +
                                  (_amountList[index] * _factor).toString(),
                              style: Theme.of(context).textTheme.headline5),
                        );
                      }),
                ),
              ],
            ),
            Icon(Icons.dinner_dining, size: 350),
          ],
        ),
      ),
    );
  }

  void _updateList() {
    setState(() {
      // When zero, edit ingredient name, other wise edit amount
      // Altername between updating name & amount until all 5 entered

      if (_numEntered < 5) {
        _itemList[_numEntered] = _ingredient;
      }

      if (_numEntered < 5) {
        _amountList[_numEntered] = _amount;
      }
      _numEntered++;
    });
  }
}
