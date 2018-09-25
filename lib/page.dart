import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './history.dart';

class PageApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return new MaterialApp(
			title: 'Colek WhatsApp',
			theme : new ThemeData(
				primaryColor: Colors.green
			),
			home: new MyPageAppState(),
		);
	}
}

class MyPageAppState extends StatefulWidget {
	MyPageAppState();

	@override
	_MyPageAppState createState() => new _MyPageAppState();
}

class _MyPageAppState extends State<MyPageAppState> with TickerProviderStateMixin {
	String number = '';
	String message = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Animation<double> _scaleAnimation;
  Animation<Offset> _panelAnimation;
  AnimationController _formAnimationController;
  AnimationController _panelAnimationController;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List> _data;
  TextEditingController messageController = new TextEditingController();


	@override
	void initState() {
		super.initState();
    
    _formAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _panelAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    Tween<double> tweenFormAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    );

    Tween<Offset> tweenPanelAnimation = Tween(
      begin: Offset(10.0, -10.0),
      end: Offset(0.0, 0.0),
    );

    _scaleAnimation = tweenFormAnimation.animate(CurvedAnimation(
      curve: Curves.linear,
      parent: _formAnimationController
    ));

    _panelAnimation = tweenPanelAnimation.animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _panelAnimationController
    ))..addStatusListener((AnimationStatus status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(Duration(milliseconds: 500));
        _formAnimationController..forward();
      }
    });

    _panelAnimationController..forward();
	}

	@override
	void dispose() {
    _formAnimationController.dispose();
		super.dispose();
	}

  Future<Null> saveHistory(String message) async {
    final SharedPreferences prefs = await _prefs;
    if (message.isNotEmpty) {
      List messageList = prefs.getStringList('messages');
      List<String> mList = new List();
      if (messageList == null) {
        mList.add(message);
        prefs.setStringList('messages', mList);
      } else {
        mList = messageList;
        mList.add(message);
        prefs.setStringList('messages', mList);
      }
    }
  }

	void onSubmitMessage() async {
    if (number.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Phone Can\'t be Empty'),
          duration: Duration(seconds: 2),
        )
      );
    } else {
      saveHistory(message);
      var url = 'https://api.whatsapp.com/send?phone=' + number + '&text=' + messageController.text;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print("TERJADI KESALAHAN");
      }
    }
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
		  	appBar: new AppBar(
		  		title: new Text("Colek WhatsApp"),
		  	),
        key: _scaffoldKey,
          body: SingleChildScrollView(
            child: new Container(
              padding: new EdgeInsets.all(20.00),
              child: new Column(
                children: <Widget>[
                    SlideTransition(
                      position: _panelAnimation,
                      child: SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.4), offset: Offset(10.0, 5.0), blurRadius: 10.0)]
                          ),
                          child: Text('Send WhatsApp Mesage Without Save Number', style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white
                          ),),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new TextField(
                            keyboardType: TextInputType.phone,
                            decoration: new InputDecoration(
                              hintText: 'Phone Number With Country Code',
                              labelText: '628777777777',
                              helperText: 'Example: 628777777777',
                              border: OutlineInputBorder(),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Icon(Icons.contact_phone, color: Colors.green),
                              )
                            ),
                            onChanged: (text) {
                              number = text;
                            },
                            maxLength: 20
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          new TextField(
                            controller: messageController,
                            decoration: new InputDecoration(
                              hintText: 'Enter Your Message',
                              labelText: 'Message',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Icon(Icons.message, color: Colors.green),
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (BuildContext context) => new HistoryPage()
                                    )).then((value) {
                                      messageController.text = value;
                                    });
                                  },
                                  highlightColor: Colors.green,
                                  splashColor: Colors.green,
                                  child: Icon(Icons.collections_bookmark, color: Colors.grey),
                                ),
                              ),
                              border: OutlineInputBorder()
                            ),
                            onChanged: (text) {
                              message = text;
                            },
                          ),
                        ],
                      ),
                    ),
                    FadeTransition(
                      opacity: _scaleAnimation,
                      child: new Container(
                        padding: new EdgeInsets.all(20.0),
                        child: new FlatButton.icon(
                          icon: new Icon(Icons.send),
                          label: new Text('Send Message'),
                          onPressed: onSubmitMessage,
                          color: Colors.green,
                          textColor: Colors.white,
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
      persistentFooterButtons: <Widget>[
        Text('Powered by Tangituru Dev')
      ],
      resizeToAvoidBottomPadding: true,
		);
	}
}