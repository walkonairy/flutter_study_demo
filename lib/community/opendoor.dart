import 'package:Flutter/common/CustomTheme.dart';
import 'package:Flutter/community/binduser.dart';
import 'package:Flutter/community/drawer.dart';
import 'package:Flutter/community/home.dart';
import 'package:Flutter/community/login.dart';
import 'package:Flutter/mobx/counter.dart';
import 'package:Flutter/utils/DoubleExit.dart';
import 'package:Flutter/utils/LocalStore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class OpenDoor extends StatefulWidget {
  const OpenDoor({Key key}) : super(key: key);
  static const String routeName = '/opendoor';

  @override
  _OpenDoorState createState() => _OpenDoorState();
}

class _OpenDoorState extends State<OpenDoor> {
  final Counter counter = new Counter();
  String villageValue;
  String gateValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocalStore.getIntLocalStorage('opencount').then((count) {
        counter.set(count);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
//          backgroundColor: Colors.white,
        title: new Text(
          '开门',
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            _openDoorButton(context),
            _selectDropDown(context),
//              _openCount(context),
          ],
        ),
      ),
    );
  }

  // ignore: slash_for_doc_comments
  /**
   * 开门按钮样式
   */
  Widget _openDoorButton(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height) / 4),
      width: 180.0,
      height: 180.0,
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
        BoxShadow(
//          color: Colors.lightBlue,
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ]),
      child: RaisedButton(
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(90.0))),
//          color: Colors.blue,
          onPressed: () {
            _openDoor(context);
          },
          padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
          child: Text(
            "OPEN",
            style: TextStyle(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.w400),
          )),
    );
  }

  // ignore: slash_for_doc_comments
  /**
   * 选择下拉小区与大门样式
   */
  Widget _selectDropDown(BuildContext context) {
    return new Padding(
      padding:
          EdgeInsets.only(left: 50.0, top: 30.0, right: 50.0, bottom: 20.0),
      child: new Column(
        children: <Widget>[
          ListTile(
            title: new Text(
              '选择小区：',
            ),
            trailing: DropdownButton<String>(
              value: villageValue,
              hint: const Text('请选择'),
              onChanged: (String newValue) {
                setState(() {
                  villageValue = newValue;
                });
              },
              items: <String>['天龙小区', '阳光小区', '湖畔小区', '花园小区']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: new Text(
              '选择大门：',
            ),
            trailing: DropdownButton<String>(
              value: gateValue,
              hint: const Text('请选择'),
              onChanged: (String newValue) {
                setState(() {
                  gateValue = newValue;
                });
              },
              items: <String>['22座大门', '23座大门', '24座大门', '25座大门']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: slash_for_doc_comments
  /**
   * 开门次数
   */
  Widget _openCount(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('开门次数: '),
            Observer(
              builder: (_) => Text(
                '${counter.value}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Text('(本地存储中取值)'),
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          height: 50.0,
          child: OutlineButton(
            textColor: Colors.redAccent,
            onPressed: () {
              counter.set(0);
            },
            child: Text(
              "重置次数",
              style: new TextStyle(fontSize: 18),
            ),
          ),
        )
      ],
    );
  }

  // ignore: slash_for_doc_comments
  /**
   * 点击开门按钮
   */
  void _openDoor(BuildContext context) {
    LocalStore.getStringLocalStorage('auth').then((data) {
      if (data != null) {
        counter.increment();
        LocalStore.setLocalStorage('opencount', counter.value);
        Navigator.pushNamed(context, Home.routeName);
      } else {
        counter.set(0);
        LocalStore.setLocalStorage('opencount', counter.value);
        Navigator.pushNamed(context, Login.routeName);
      }
    }).catchError((error) {
      Navigator.pushNamed(context, Login.routeName);
    });
  }

  int last = 0;

  /// 双击返回退出应用
  Future<bool> doubleClickBack() {
    print('触发双击退出事件');
    //计算两次时间间隔
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - last > 2000) {
      last = DateTime.now().millisecondsSinceEpoch;
      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  '再次点击返回键退出应用',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
