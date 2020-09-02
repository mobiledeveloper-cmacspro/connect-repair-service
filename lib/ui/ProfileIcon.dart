import 'package:flutter/cupertino.dart';
import 'package:repairservices/ui/Login/LoginIconBloc.dart';

import '../ProfileV.dart';

class ProfileIcon extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ProfileIconState();
}

class ProfileIconState extends State<ProfileIcon>{

  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
    stream: LoginIconBloc.loggedInStream,
    initialData: false,
    builder: (context, snapshot) => snapshot.data
        ? GestureDetector(
      onTap: () {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => Profile()));
      },
      child: Image.asset(
        'assets/user-icon.png',
        height: 25,
      ),
    )
        : Container(),
  );


}