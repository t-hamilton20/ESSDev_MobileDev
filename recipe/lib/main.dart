import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
      theme: ThemeData(primaryColor: Colors.red, accentColor: Colors.redAccent),
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
            ListTile(
                title: const Text("Recipes"),
                onTap: () {
                  Navigator.pop(context);
                }),
            ListTile(
                title: const Text("Pasta Sizing"),
                onTap: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
      body: new Padding(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                child: new ListView.builder(
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(ingredients[index].output()));
                  },
                ),
              ),
              new SizedBox(height: 20),
              new TextField(
                cursorColor: Colors.redAccent,
                decoration: new InputDecoration(hintText: "Input Ingredient"),
                onSubmitted: (String ingredientsInput) {
                  setState(() {
                    ingredient = ingredientsInput;
                  });
                },
              ),
              new SizedBox(height: 10),
              new TextField(
                cursorColor: Colors.redAccent,
                decoration: new InputDecoration(hintText: "Input Amount"),
                onSubmitted: (String amountsInput) {
                  setState(() {
                    amount = double.parse(amountsInput);
                  });
                },
              ),
              new SizedBox(height: 10),
              new TextField(
                cursorColor: Colors.redAccent,
                decoration: new InputDecoration(
                    hintText: "Input Unit (ex: cups, tbsp, etc.)"),
                onSubmitted: (String unitsInput) {
                  setState(() {
                    unit = unitsInput;
                  });
                },
              ),
              new SizedBox(height: 10),
              new Slider(
                value: multiplier,
                min: 1,
                max: 10,
                divisions: 10,
                inactiveColor: Colors.red,
                activeColor: Colors.redAccent,
                label: multiplier.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    multiplier = value;
                  });
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: Text("Add Ingredient"),
                onPressed: () {
                  ingredients[count].name = ingredient;
                  ingredients[count].quantity = amount;
                  ingredients[count].unit = unit;
                  count++;
                  print(count);
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
  String unit;

  Ingredient({this.name = "", this.quantity = 0, this.unit = ""});

  String output() {
    if (name == "" && quantity == 0 && unit == "") {
      return "";
    } else {
      return this.name +
          ": " +
          this.quantity.toString() +
          " " +
          this.unit +
          "(s)";
    }
  }

  void multiply(double multiplier) {
    this.quantity = quantity * multiplier;
  }
}
