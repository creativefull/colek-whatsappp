import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import './status-detail.dart';
import 'package:simple_permissions/simple_permissions.dart';

class StatusApp extends StatefulWidget {
  @override
  _StatusAppState createState() => _StatusAppState();
}

class _StatusAppState extends State<StatusApp> {
  List<FileSystemEntity> images = [];
  Permission permission;
  bool readFile = false;

  Future<Null> get _localFile async {
    final path = await getExternalStorageDirectory();
    String folderStatus = path.path + "/WhatsApp/Media/.Statuses";
    List<FileSystemEntity> file = Directory.fromUri(Uri.parse(folderStatus)).listSync();
    List<FileSystemEntity> uriImages = [];

    file.forEach((fileName) {
      var fn = fileName.uri;
      List<String> extImg = ['jpg','jpeg','png','gif'];

      if (extImg.indexOf(fn.toString().split(".")[2]) >= 0) {
        uriImages.add(fileName);
      }

      setState(() {
        images = uriImages;
      });
    });

    setState(() {
      images = file;
    });
    // return File('$path/counter.text');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();
    _localFile;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  requestPermission() async {
    final res = await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    if (res.index == 3) {
      setState(() {
        readFile = true;
      });
      _localFile;
    }
  }

  checkPermission() async {
    // Permission.values.forEach((p) => print(p));
    bool res = await SimplePermissions.checkPermission(Permission.ReadExternalStorage);
    setState(() {
      readFile = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            backgroundColor: Colors.purple,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Image.asset('assets/img/bg-status.jpg', fit: BoxFit.cover),
              title: Text('Story Downloader'),
            ),
          ),
          SliverSafeArea(
            sliver: SliverFillRemaining(
              child: !readFile ? Container(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Colek Whatsapp Read File Permission Denied, Please Enable it', textAlign: TextAlign.center, style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.grey
                      )),
                      FlatButton.icon(
                        splashColor: Colors.white,
                        color: Colors.purple,
                        textColor: Colors.white,
                        icon: Icon(Icons.check_circle),
                        label: Text('Enable Read Files'),
                        onPressed: requestPermission,
                      )
                    ],
                  ),
                ),
              ) : GridView.builder(
                itemCount: images.length,
                // physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => new StatusDetail(file: images[index])
                      ));
                    },
                    child: Hero(
                      tag: images[index].uri,
                      child: Image.file(images[index], fit: BoxFit.cover,),
                    ),
                  );
                }
              ),
            ),
          )
        ],
      ),
    );
  }
}