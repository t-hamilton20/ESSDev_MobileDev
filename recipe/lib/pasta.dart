import 'package:flutter/material.dart';

class Pasta extends StatefulWidget {
  const Pasta({Key? key}) : super(key: key);

  @override
  PastaState createState() => PastaState();
}

class PastaState extends State<Pasta> {
  double servings = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Pasta Sizing"),
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
          padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  //textfield for serving size input
                  decoration: new InputDecoration(
                      labelText: "Serving Size",
                      hintText: "Input Number of People"),
                  onSubmitted: (String servingsInput) {
                    setState(() {
                      servings = double.parse(servingsInput);
                    });
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
