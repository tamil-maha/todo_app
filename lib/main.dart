import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo/event.dart';
import 'package:todo/home/home.dart';
import 'package:todo/login/login_page.dart';
import 'package:todo/login_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return InheritedEventWidget(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: SplashPage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async{
    CollectionReference addressRef = await FirebaseFirestore.instance
        .collection('app_customers')
        .doc('Maha')
        .collection("test");
    Map<String, dynamic> dataToInsert = new Map();
    dataToInsert['title'] = 'Test 1';
    dataToInsert['address'] = 'Karur';
    await addressRef.add(dataToInsert);
    setState(() {

      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    LoginInfo.isAlreadyAuthenticated().then((result) async {
      if(result){
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => HomePage()));
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (_) => LoginPage(),
                settings: RouteSettings(name: "/Login")),
                (Route<dynamic> route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container();
  }
}

