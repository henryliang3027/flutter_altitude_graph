import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_altitude_graph/altitude_graph.dart';
import 'package:flutter_altitude_graph/altitude_point_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const List<String> paths = [
  "assets/raw/HUANQINGHAIHU.json",
  "assets/raw/CHUANZANGNAN.json",
  "assets/raw/HUANQINGHAIHU.json",
  "assets/raw/CHUANZANGNAN.json",
  "assets/raw/HUANQINGHAIHU.json",
  "assets/raw/CHUANZANGNAN.json",
  "assets/raw/HUANQINGHAIHU.json",
  "assets/raw/CHUANZANGNAN.json",
  "assets/raw/HUANQINGHAIHU.json",
  "assets/raw/CHUANZANGNAN.json",
  "assets/raw/HUANQINGHAIHU.json",
  "assets/raw/CHUANZANGNAN.json",
  "assets/raw/HUANQINGHAIHU.json",
  "assets/raw/CHUANZANGNAN.json",
  "assets/raw/HUANQINGHAIHU.json",
  "assets/raw/CHUANZANGNAN.json",
  "assets/raw/HUANQINGHAIHU.json",
  "assets/raw/CHUANZANGNAN.json",
  "assets/raw/HUANQINGHAIHU.json",
  "assets/raw/CHUANZANGNAN.json",
];

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late List<AltitudePoint> _altitudePointList;
  double _maxScale = 1.0;
  int dataIndex = 0;
  bool animating = false;
  late AnimationController controller;
  late CurvedAnimation _elasticAnimation;

  @override
  void initState() {
    super.initState();

    _altitudePointList = [];

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _elasticAnimation =
        CurvedAnimation(parent: controller, curve: const ElasticOutCurve(1.0));

    changeData().then((list) {
      setState(() {
        controller.forward();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<List<AltitudePoint>> changeData() {
    int a = dataIndex++;
    return parseGeographyData(paths[a % paths.length]).then((list) {
      _altitudePointList = list;

      double miters = list.last.point.dx;
      if (miters > 0) {
        _maxScale = max(miters / 50.0, 1.0);
      } else {
        _maxScale = 1.0;
      }
      return list;
    });
  }

  _onRefreshBtnPress() {
    if (animating) return;
    animating = true;

    var changeDataFuture = changeData();
    controller.duration = const Duration(seconds: 1);
    controller.reverse().then((_) {
      changeDataFuture.then((_) {
        setState(() {
          controller.duration = const Duration(seconds: 3);
          controller.forward();
          animating = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Altitude Graph"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: _onRefreshBtnPress,
          ),
        ],
      ),
      body: AltitudeGraphView(
        _altitudePointList,
        maxScale: _maxScale,
        animation: _elasticAnimation,
      ),
    );
  }
}
