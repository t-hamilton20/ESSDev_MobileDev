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
  double amount = 0;
  double multiplier = 1;

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
      body: new Container(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Text(ingredient + ": " + (amount).toString()),
              new TextField(
                decoration: new InputDecoration(hintText: "Input Ingredient"),
                onSubmitted: (String ingredientsInput) {
                  setState(() {
                    ingredient = ingredientsInput;
                  });
                },
              ),
              new TextField(
                decoration:
                    new InputDecoration(hintText: "Input Amount (Cups)"),
                onSubmitted: (String amountsInput) {
                  setState(() {
                    amount = double.parse(amountsInput);
                  });
                },
              ),
              new TextField(
                decoration: new InputDecoration(hintText: "Multiplier"),
                onSubmitted: (String multiplierInput) {
                  setState(() {
                    multiplier = double.parse(multiplierInput);
                  });
                },
              ),
              ElevatedButton(
                child: Text("Multiply!"),
                style: ButtonStyle(backgroundColor: Colors.red),
                onPressed: () {
                  setState(() {
                    amount = amount * multiplier;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
