import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repairservices/HomeMaterial.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/Login/LoginIconBloc.dart';
import 'package:repairservices/utils/ISClient.dart';

import '../../Login.dart';
import '../../ProfileV.dart';

class LoginIcon extends StatefulWidget {
  final double paddingTop, paddingLeft, paddingRight, paddingBottom;

  LoginIcon(
      {this.paddingTop = 0.0,
      this.paddingLeft = 0.0,
      this.paddingRight = 0.0,
      this.paddingBottom = 0.0});

  @override
  State<StatefulWidget> createState() => LoginIconState();
}

class LoginIconState extends State<LoginIcon> {
  @override
  void initState() {
    ISClientO.instance.isTokenAvailable().then((bool logged) async {
      LoginIconBloc.changeLoggedInStatus(logged);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
        stream: LoginIconBloc.loggedInStream,
        initialData: false,
        builder: (context, snapshot) => snapshot.data
            ? Container()
            : Padding(
                padding: EdgeInsets.only(
                    left: widget.paddingLeft,
                    right: widget.paddingRight,
                    top: widget.paddingTop,
                    bottom: widget.paddingBottom),
                child: GestureDetector(
                  child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          R.string.login,
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      )),
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => LoginV()));
                  },
                )),
      );
}
