import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_altitude_graph/altitude_graph.dart';

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
      home: const MyGraphPage(),
    );
  }
}

class MyGraphPage extends StatelessWidget {
  const MyGraphPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Altitude Graph"),
      ),
      body: ListView(
        children: const <Widget>[
          MyGraph(altitudePointList: [
            ChartDateValuePair(
              date: '2022-10-03',
              point: Offset(0.0, 26.0),
              value: 26.0,
            ),
            ChartDateValuePair(
              date: '2022-10-04',
              point: Offset(1.0, 26.34),
              value: 26.34,
            ),
            ChartDateValuePair(
              date: '2022-10-05',
              point: Offset(2.0, 26.222),
              value: 26.222,
            ),
          ]),
          MyGraph(
            altitudePointList: [
              ChartDateValuePair(
                date: '2022-10-03',
                point: Offset(0.0, 55.0),
                value: 26.0,
              ),
              ChartDateValuePair(
                date: '2022-10-04',
                point: Offset(1.0, 47.34),
                value: 26.34,
              ),
              ChartDateValuePair(
                date: '2022-10-05',
                point: Offset(2.0, 657.222),
                value: 26.222,
              ),
              ChartDateValuePair(
                date: '2022-10-05',
                point: Offset(2.0, 234.222),
                value: 26.222,
              ),
              ChartDateValuePair(
                date: '2022-10-05',
                point: Offset(2.0, 34.222),
                value: 26.222,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class MyGraph extends StatefulWidget {
  const MyGraph({
    Key? key,
    required this.altitudePointList,
  }) : super(key: key);

  final List<ChartDateValuePair> altitudePointList;

  @override
  State<MyGraph> createState() => _MyGraphState();
}

// const List<String> paths = [
//   "assets/raw/HUANQINGHAIHU_2.json",
//   "assets/raw/HUANQINGHAIHU.json",
//   "assets/raw/HUANQINGHAIHU_2.json",
// ];

class _MyGraphState extends State<MyGraph> with SingleTickerProviderStateMixin {
  double _maxScale = 1.0;
  int dataIndex = 0;
  bool animating = false;
  late AnimationController controller;
  late CurvedAnimation _elasticAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _elasticAnimation =
        CurvedAnimation(parent: controller, curve: const ElasticOutCurve(1.0));

    double miters = widget.altitudePointList.last.point.dx;
    if (miters > 0) {
      _maxScale = max(miters / 50.0, 3.0);
    } else {
      _maxScale = 3.0;
    }

    setState(() {
      controller.forward();
    });

    // changeData().then((list) {
    //   setState(() {
    //     controller.forward();
    //   });
    // });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Future<List<AltitudePoint>> changeData() {
  //   int a = dataIndex++;
  //   return parseGeographyData(paths[a % paths.length]).then((list) {
  //     _altitudePointList = list;

  //     double miters = list.last.point.dx;
  //     if (miters > 0) {
  //       _maxScale = max(miters / 50.0, 1.0);
  //     } else {
  //       _maxScale = 1.0;
  //     }
  //     return list;
  //   });
  // }

  // _onRefreshBtnPress() {
  //   if (animating) return;
  //   animating = true;

  //   var changeDataFuture = changeData();
  //   controller.duration = const Duration(seconds: 1);
  //   controller.reverse().then((_) {
  //     changeDataFuture.then((_) {
  //       setState(() {
  //         controller.duration = const Duration(seconds: 3);
  //         controller.forward();
  //         animating = false;
  //       });
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.maxFinite,
      child: AltitudeGraphView(
        widget.altitudePointList,
        maxScale: _maxScale,
        animation: _elasticAnimation,
      ),
    );
  }
}
