import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
        });
  }
}

class FirstScreen extends StatefulWidget {
  FirstScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final _controller = TextEditingController();
  double _r = 0.0;
  double _g = 0.0;
  double _b = 0.0;

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        color: Color.fromARGB(200, _r.toInt(), _g.toInt(), _b.toInt()),
        child: Column(
          children: <Widget>[
            Text('Home Screen', style: TextStyle(fontSize: 24)),
            Padding(padding: EdgeInsets.all(20.0)),
            TextField(
              controller: _controller,
              style: TextStyle(fontSize: 24),
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            Slider(
              min: 0.0,
              max: 255.0,
              value: _r,
              divisions: 255,
              onChanged: (double value) {
                setState(() {
                  _r = value;
                });
              },
            ),
            Slider(
              min: 0.0,
              max: 255.0,
              value: _g,
              divisions: 255,
              onChanged: (double value) {
                setState(() {
                  _g = value;
                });
              },
            ),
            Slider(
              min: 0.0,
              max: 255.0,
              value: _b,
              divisions: 255,
              onChanged: (double value) {
                setState(() {
                  _b = value;
                });
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.open_in_new),
        onPressed: () {
          savePrefs();
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text("saved"),
                    content: Text("save preferences"),
                  ));
        },
      ),
    );
  }

  void loadPrefs() async {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {
        _r = (prefs.getDouble('r') ?? 0.0);
        _g = (prefs.getDouble('g') ?? 0.0);
        _b = (prefs.getDouble('b') ?? 0.0);
        _controller.text = (prefs.getString('input') ?? '');
      });
    });
  }

  void savePrefs() async {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {
        prefs.setDouble('r', _r);
        prefs.setDouble('g', _g);
        prefs.setDouble('b', _b);
        prefs.setString('input', _controller.text);
      });
    });
  }
}
