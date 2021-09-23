import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'Database.dart';
//import 'package:firebase_core/firebase_core.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //@override
  late DatabaseHandler handler;

  Future<int> addUsers() async {
    User firstUser = User(name: "peter", age: 24, country: "Lebanon");
    User secondUser = User(name: "john", age: 31, country: "United Kingdom");
    List<User> listOfUsers = [firstUser, secondUser];
    return await this.handler.insertUser(listOfUsers);
  }

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {
      await this.addUsers();
      print("Initiliazing!");
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Trivia Game"),
        ),
        body: FutureBuilder(
          future: this.handler.retrieveUsers(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.delete_forever),
                    ),
                    key: ValueKey<int>(snapshot.data![index].id!),
                    onDismissed: (DismissDirection direction) async {
                      await this.handler.deleteUser(snapshot.data![index].id!);
                      setState(() {
                        snapshot.data!.remove(snapshot.data![index]);
                      });
                    },
                    child: Card(
                        child: ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(snapshot.data![index].age.toString()),
                    )),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));

    /*return Scaffold(
      appBar: AppBar(
        title: Text("Trivia Game"),
      ),
      body: new Padding(
        //used to add space around content
        padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new SizedBox(height: 20), //added for spacing
              new TextField(
                //textfield for ingredient input
                decoration: new InputDecoration(
                    labelText: "Username", hintText: "Input your username"),
                onSubmitted: (String usernameInput) {
                  setState(() {});
                },
              ),
              new SizedBox(height: 10), //added for spacing
              new TextField(
                //textfield for amount input
                decoration: new InputDecoration(
                    labelText: "Password", hintText: "Input your password"),
                onSubmitted: (String passwordInput) {
                  setState(() {});
                },
              ),
              new SizedBox(height: 10), //added for spacing
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
                child: Text("Login"),
                onPressed: () {
                  setState(() {});
                },
              ),
              new SizedBox(height: 10), //added for spacing
            ],
          ),
        ),
      ),
    );*/
  }
}

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
