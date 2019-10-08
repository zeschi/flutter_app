import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  static const String _title = "Flutter demo";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyStatefulWidget();
  }
}

class _MyStatefulWidget extends State<MyStatefulWidget> {
  int count = 0;
  static String policyText =
      '{"expiration": "2020-01-01T12:00:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';

//进行utf8编码
  static List<int> policyText_utf8 = utf8.encode(policyText);

//进行base64编码
  static String policy_base64 = base64.encode(policyText_utf8);

//再次进行utf8编码
  static List<int> policy = utf8.encode(policy_base64);
  static String accesskey = '你的accesskey';

//进行utf8 编码
  static List<int> key = utf8.encode(accesskey);

//通过hmac,使用sha1进行加密
//  static List<int> signature_pre  = new Hmac(sha1, key).convert(policy).bytes;

//最后一步，将上述所得进行base64 编码
  String signature = "";

  void addCount() {
    setState(() async {
//      count++;
      File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      Options options = new Options();
      options.responseType = ResponseType.PLAIN;
      Dio dio = new Dio(options);
      String fileName = "uploadImage.jpg";
      //创建一个formdata，作为dio的参数
      FormData data = new FormData.from({
        'Filename': '文件名，随意',
        'key': "可以填写文件夹名（对应于oss服务中的文件夹）/" + fileName,
        'policy': policy_base64,
        'OSSAccessKeyId': "accessid",
        'success_action_status': '200', //让服务端返回200，不然，默认会返回204
        'signature': signature,
        'file': new UploadFileInfo(imageFile, "imageFileName")
      });
      try {
        Response response = await dio.post("", data: data);
        print(response.headers);
        print(response.data);
      } on DioError catch (e) {
        print(e.message);
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("test")),
      body: Center(child: Text("press $count")),
      backgroundColor: Colors.blueGrey.shade100,
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(height: 50)),
      floatingActionButton: FloatingActionButton(
        onPressed: addCount,
        tooltip: "Increment",
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

}


class TabbedAppBarSample extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: choices.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Tabbed AppBar"),
            bottom: TabBar(
                isScrollable: true,
                tabs: choices.map((Choice choice) {
                  return Tab(
                      text: choice.title,
                      icon: Icon(choice.icon));
                }).toList()),
          ),
          body: TabBarView(
            children: choices.map((Choice choice) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ChoiceCard(choice: choice),
              );
            }).toList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: null,
            child: Icon(Icons.add),),
        ),
      ),
    );
  }

}

class Choice {
  const Choice({ this.icon, this.title});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'CAR', icon: Icons.directions_car),
  const Choice(title: 'BICYCLE', icon: Icons.directions_bike),
  const Choice(title: 'BOAT', icon: Icons.directions_boat),
  const Choice(title: 'BUS', icon: Icons.directions_bus),
  const Choice(title: 'TRAIN', icon: Icons.directions_railway),
  const Choice(title: 'WALK', icon: Icons.directions_walk),
];

class ChoiceCard extends StatelessWidget {

  const ChoiceCard({Key key, this.choice}) :super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .display1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128, color: textStyle.color),
            Text(choice.title, style: textStyle)
          ],
        ),
      ),
    );
  }
}

class BottomApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "bottom app",
      home: BottomTabStatefulWidget(),
    );
  }

}


class BottomTabStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomTabState();
  }
}

class _BottomTabState extends State<BottomTabStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle _style = TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue);

  static const List<Widget> _widgetOptions = <Widget>[
    Text("Index 0 Home", style: _style),
    FlatButton(
      onPressed: null,
      child: Text("Index 2 home", style: _style,),
      color: Colors.blue,),
    TextField(

    )
  ];

  void _onItemTaped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BottomNav"),),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.business),
              title: Text("business")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.school),
              title: Text("school")
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTaped,
      ),
    );
  }

}








