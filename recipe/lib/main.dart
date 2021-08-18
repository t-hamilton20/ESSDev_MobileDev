import 'package:flutter/material.dart';
import 'pasta.dart';

void main() {
  runApp(new MaterialApp(
      routes: {
        '/pasta': (context) => Pasta(),
        '/recipe': (context) => RecipeApp()
      },
      theme: ThemeData(
          primaryColor: Colors.blue[900], accentColor: Colors.blueAccent),
      home: new RecipeApp()));
}

class RecipeApp extends StatefulWidget {
  const RecipeApp({Key? key}) : super(key: key);

  @override
  _RecipeAppState createState() => _RecipeAppState();
}

class _RecipeAppState extends State<RecipeApp> {
  String ingredient = "";
  String unit = "";
  double amount = 0;
  double multiplier = 1;
  int count = 0;

  var ingredients = List<Ingredient>.generate(10, (index) {
    //generates list of ten ingredient objects
    return Ingredient(
      name: "",
      quantity: 0,
      unit: "",
    );
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Recipe App"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Card(
                child: ListTile(
                    leading: Icon(Icons.fastfood, color: Colors.blueAccent),
                    title: const Text("Recipes"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/recipe');
                    })),
            Card(
                child: ListTile(
                    leading: Icon(Icons.restaurant, color: Colors.blueAccent),
                    title: const Text("Pasta Sizing"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/pasta');
                    }))
          ],
        ),
      ),
      body: new Padding(
        //used to add space around content
        padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                child: new ListView.builder(
                  //listview.builder creates a text box tile for every item in the ingredients list
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(ingredients[index].output()));
                  },
                ),
              ),
              new SizedBox(height: 20), //added for spacing
              new TextField(
                //textfield for ingredient input
                decoration: new InputDecoration(
                    labelText: "Ingredient", hintText: "Input Ingredient"),
                onSubmitted: (String ingredientsInput) {
                  setState(() {
                    ingredient = ingredientsInput;
                  });
                },
              ),
              new SizedBox(height: 10), //added for spacing
              new TextField(
                //textfield for amount input
                decoration: new InputDecoration(
                    labelText: "Amount", hintText: "Input Amount"),
                onSubmitted: (String amountsInput) {
                  setState(() {
                    amount = double.parse(amountsInput);
                  });
                },
              ),
              new SizedBox(height: 10), //added for spacing
              new TextField(
                //textfield for unit input
                decoration: new InputDecoration(
                    labelText: "Unit",
                    hintText: "Input Unit (ex: cups, tbsp, etc.)"),
                onSubmitted: (String unitsInput) {
                  setState(() {
                    unit = unitsInput;
                  });
                },
              ),
              new SizedBox(height: 10), //added for spacing
              new Slider(
                //slider for multiplier input
                value: multiplier,
                min: 1,
                max: 10,
                divisions: 9,
                inactiveColor: Colors.blue[900],
                activeColor: Colors.blueAccent,
                label: multiplier.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    multiplier = value;
                    for (int i = 0; i < ingredients.length; i++) {
                      //iterate through each ingredient and set the multiplier to the inputted value
                      ingredients[i].setMultiplier(multiplier);
                    }
                  });
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
                child: Text("Add Ingredient"),
                onPressed: () {
                  //when pressed, set the names, quantity, and unit for the current ingredient. then increment the counter and refresh
                  ingredients[count].setName(ingredient);
                  ingredients[count].setQuantity(amount);
                  ingredients[count].setUnit(unit);
                  count++;
                  setState(() {});
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Ingredient {
  String name;
  double quantity;
  double multiplier;
  String unit;

  Ingredient(
      {this.name = "", this.quantity = 0, this.multiplier = 1, this.unit = ""});

  String output() {
    if (name == "" && quantity == 0 && unit == "") {
      return "";
    } else {
      return this.getName() +
          ": " +
          (this.getQuantity() * this.getMultiplier()).toString() +
          " " +
          this.getUnit() +
          "(s)";
    }
  }

  void setName(String newName) {
    this.name = newName;
  }

  void setQuantity(double newQuantity) {
    this.quantity = newQuantity;
  }

  void setMultiplier(double newMultiplier) {
    this.multiplier = newMultiplier;
  }

  void setUnit(String newUnit) {
    this.unit = newUnit;
  }

  String getName() {
    return name;
  }

  double getQuantity() {
    return quantity;
  }

  double getMultiplier() {
    return multiplier;
  }

  String getUnit() {
    return unit;
  }
}
