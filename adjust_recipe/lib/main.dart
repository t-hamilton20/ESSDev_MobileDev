import 'package:flutter/material.dart';

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.green,
      ),
      home: RecipeAdjustPage(title: 'Recipe Adjuster'),
    );
  }
}

class RecipeAdjustPage extends StatefulWidget {
  RecipeAdjustPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _RecipeAdjustPageState createState() => _RecipeAdjustPageState();
}

class _RecipeAdjustPageState extends State<RecipeAdjustPage>
    with AutomaticKeepAliveClientMixin<RecipeAdjustPage> {
  @override
  bool get wantKeepAlive => true;
  int _ingredient = 0;
  int _factor = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

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
          title: Text(widget.title),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Text('Adjust ingredient amount',
                  style: Theme.of(context).textTheme.button),
            ),
            Icon(Icons.dinner_dining, size: 350),
          ],
        ),
      ),
    );
  }
}
