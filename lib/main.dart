import 'package:flutter/material.dart';
import 'page.dart';
import './history.dart';
import './status.dart';

void main() => runApp(new MaterialApp(
  theme: ThemeData(
    primaryColor: Colors.green
  ),
  routes: {
    '/' : (BuildContext context) => new PageApp(),
    '/history' : (BuildContext context) => HistoryPage(),
    '/status' : (BuildContext context) => StatusApp()
  },
  initialRoute: '/',
));