import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:flutter/scheduler.dart' show timeDilation;

class StatusDetail extends StatefulWidget {
  final FileSystemEntity file;  
  StatusDetail({
    Key key,
    @required this.file
  }):super(key:key);

  @override
  _StatusDetailState createState() => _StatusDetailState();
}

class _StatusDetailState extends State<StatusDetail> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String dirWork = '';

  @override
  void initState() {
    super.initState();
    dirWorkApp;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> get dirWorkApp async {
    final appDir = await getExternalStorageDirectory();
    String dirWorks = appDir.path + '/DCIM/ColekWhatsApp';
    setState(() {
      dirWork = dirWorks;
    });
    return dirWorks;
  }

  Future<Null> onDownload() async {
    String dirWork = await dirWorkApp;
    if (!new Directory(dirWork).existsSync()) {
      print("Create Directory ${dirWork}");
      new Directory(dirWork).create();
    }

    DateTime dateTime = DateTime.now();
    var file = 'cw' + dateTime.year.toString() + dateTime.month.toString() + dateTime.day.toString() + dateTime.hour.toString() + dateTime.second.toString() + dateTime.millisecond.toString() + '.jpg';
    File fileToWrite = File("${dirWork}/$file");
    // print(fileToWrite);
    // print(widget.file.uri.path);
    String base64File = base64Encode(File(widget.file.uri.path).readAsBytesSync());
    File(widget.file.uri.path).copy(fileToWrite.path).then((value) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Download Success'),
      ));
    });
    // print(base64File);
    // fileToWrite.writeAsStringSync(base64File);
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 3.0;
    return Material(
      child: Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              pinned: true,
              backgroundColor: Colors.purple,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Hero(
                  tag: widget.file.uri,
                  child: Image.file(widget.file, fit: BoxFit.cover),
                ),
                title: Container(
                  color: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: Text('Story Downloader', style: TextStyle(
                    // fontSize: 12.0
                  )),
                ),
              )
            ),

            SliverFillRemaining(
              child: Container(
                padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      leading: CircleAvatar(
                        child: Text("S"),
                        backgroundColor: Colors.purple
                      ),
                      title: Text(widget.file.uri.path.split(".")[1].split("/")[1]),
                      subtitle: Text('Powered by Colek WhatsApp'),
                      trailing: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.purple
                        ),
                        padding: EdgeInsets.all(5.0),
                        child: Text('Images', style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0
                        )),
                      ),
                    ),
                    
                    SizedBox(
                      height: 20.0,
                    ),
                    RawMaterialButton(
                      onPressed: onDownload,
                      fillColor: Colors.purple,
                      splashColor: Colors.white,
                      child: Text('Download', style: TextStyle(color: Colors.white),),
                    ),

                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: Center(
                        child: Text('Download Location : ${dirWork}', style: TextStyle(
                          fontSize: 10.0
                        )),
                      ),
                    )
                  ]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}