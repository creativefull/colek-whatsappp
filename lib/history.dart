import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List _data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDataMessage();
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<Null> getDataMessage() async {
    final SharedPreferences prefs = await _prefs;
    List data = prefs.getStringList('messages');
    if (data != null) {
      setState(() {
        _data = data.reversed.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Fast Message'),
              centerTitle: true,
            ),
          ),

          new SliverSafeArea(
            sliver: SliverFillRemaining(
              child: ListView.builder(
                itemCount: _data.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (cotext, index) {
                  var msg = _data[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop(msg);
                    },
                    splashColor: Colors.green,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        child: Icon(Icons.text_format),
                      ),
                      title: Text(msg),
                    ),
                  );
                },
              ),
            ),
          )
          // SliverFixedExtentList(
          //   itemExtent: 10.0,
          //   delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          //     return Text("item data ${index}");
          //   }),
          // )
        ],
      ),
    );
  }
}