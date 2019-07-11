import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => FirstScreen(),
          '/second': (context) => SecondScreen('Second'),
          '/third': (context) => SecondScreen('Third'),
        });
  }
}

class FirstScreen extends StatefulWidget {
  FirstScreen({Key key}) : super(key: key);

  @override
  _FirstScreenState createState() => new _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Home Screen',
            style: TextStyle(fontSize: 24), key: ValueKey('firstScreenText')),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('Home'),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text('Next'),
            icon: Icon(Icons.navigate_next,
                key: ValueKey('firstScreenNextButton')),
          ),
        ],
        onTap: (int value) {
          if (value == 1) Navigator.pushNamed(context, '/second');
        },
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final String _value;

  SecondScreen(this._value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Next"),
      ),
      body: Center(
        child: Text('$_value Screen',
            style: TextStyle(fontSize: 24), key: ValueKey('secondScreenText')),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('prev'),
            icon: Icon(Icons.navigate_before,
                key: ValueKey('secondScreenBackButton')),
          ),
          BottomNavigationBarItem(
            title: Text('?'),
            icon: Icon(Icons.android, key: ValueKey('secondScreenNextButton')),
          )
        ],
        onTap: (int value) {
          if (value == 0) Navigator.pop(context);
          if (value == 1) Navigator.pushNamed(context, '/third');
        },
      ),
    );
  }
}
