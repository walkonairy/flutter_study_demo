import 'dart:developer';

import 'package:Flutter/community/home.dart';
import 'package:Flutter/community/opendoor.dart';
import 'package:Flutter/utils/LocalStore.dart';
import 'package:flutter/material.dart';
import 'package:Flutter/mobx/counter.dart';

class BindHouse extends StatefulWidget {
  @override
  _BindHouseState createState() => _BindHouseState();

  const BindHouse({Key key}) : super(key: key);
  static const String routeName = '/bindhouse';
}

class _BindHouseState extends State<BindHouse> {
  final Counter counter = new Counter();
  bool _checkValue = false;
  final _houseList = <String>[
    '天龙小区2401',
    '天龙小区2402',
    '天龙小区2403',
    '碧桂园1街24号',
    '碧桂园2街25号',
    '阳光小区0128号',
    '湖畔小区914号',
  ];

  @override
  Widget build(BuildContext context) {
    BorderSide _outBorderSide = BorderSide(color: Colors.grey[500], width: 0);
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          '绑定房屋',
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: new Padding(
          padding: EdgeInsets.only(top: 1.0), //暂时放着，方便控制下面的容器
          child: new Column(
            children: <Widget>[
              new Container(
                height: 300.0,
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  border: Border(
                    left: _outBorderSide,
                    right: _outBorderSide,
                    top: _outBorderSide,
                    bottom: _outBorderSide,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: _ableBindHouses(),
              ),
              new Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.only(left: 24.0, right: 24.0),
                child: Column(
                  children: <Widget>[
                    _bindHouseButton(context),
                    const SizedBox(
                      height: 20.0,
                    ),
//                    _logoutButton(context),
                  ],
                ),
              )
            ],
          )),
    );
  }

  // ignore: slash_for_doc_comments
  /**
   * 绑定房屋列表
   */
  Widget _ableBindHouses() {
    return new Scrollbar(
      child: ListView.builder(
        itemCount: _houseList.length,
        itemBuilder: (BuildContext context, int index) {
          final String item = _houseList[index];
          return new CheckboxListTile(
            secondary: const Icon(Icons.home),
            title: new Text(item),
            value: _checkValue,
            onChanged: (bool value) {
              print(index);
              setState(() {
                this._checkValue = !this._checkValue;
              });
            },
          );
        },
      ),
    );
  }

  // ignore: slash_for_doc_comments
  /**
   * 绑定房屋按钮
   */
  Widget _bindHouseButton(BuildContext context) {
    return new RaisedButton(
      onPressed: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          Home.routeName,
          ModalRoute.withName(OpenDoor.routeName),
        );
      },
      child: Text(
        "绑定",
        style: new TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// 登出按钮
  Widget _logoutButton(BuildContext context) {
    return new MaterialButton(
      minWidth: double.infinity,
      height: 50.0,
      color: Colors.lightGreen,
      textColor: Colors.white,
      onPressed: () {
        _logout(context);
      },
      child: Text(
        "退出登录",
        style: new TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// 退出的方法
  _logout(BuildContext context) {
    LocalStore.removeLocalStorage('auth').then((isOk) {
      print(isOk);
      if (isOk) {
        counter.set(0);
        LocalStore.setLocalStorage('opencount', counter.value);
        print(counter.value);
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          (route) => route == null,
        );
      }
    });
  }
}
