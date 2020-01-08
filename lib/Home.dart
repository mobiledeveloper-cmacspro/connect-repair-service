import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'Login.dart';

class HomeV extends StatelessWidget {
  const HomeV();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.white,
        middle: Container(
          child: Image.asset(
            'assets/schuco.png',
            fit: BoxFit.contain,
            height: 36,
          ),
        ),
        leading: Container(
          margin: EdgeInsets.only(left: 8,right: 0,top: 0,bottom: 0),
          child: GestureDetector(
            onTap: () {
              debugPrint('Menu button Tapped');
            },
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/hamburgerGreen.png',
                  height: 25,
                )
              ],
            ),
          ),
          width: 40,
        ),

        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget> [
            Container(
              margin: EdgeInsets.only(right: 8,left: 8,top: 0,bottom: 0),
              child: GestureDetector(
                onTap: () {
                  debugPrint('Car button taped');
                },
                child: Image.asset(
                  'assets/shopping-cart.png',
                  height: 25,
                ),

              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 8,left: 8,top: 0,bottom: 0),
              child: GestureDetector(
                onTap: () {
                  debugPrint('Car button taped');
                },
                child: Image.asset(
                  'assets/user-icon.png',
                  height: 25,
                ),

              ),
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),

      child: new HomeBody()
    );
  }

}
class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build


//    void showAlertDialog(BuildContext context) {
//      showCupertinoDialog(
//          context: context,
//          builder: (BuildContext context ) => CupertinoAlertDialog(
//            title: const Text("New Alert for you"),
//            actions: <Widget>[
//              CupertinoDialogAction(
//                child: const Text("Nope"),
//                isDestructiveAction: true,
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//              ),
//              CupertinoDialogAction(
//                child: const Text("Absolutly"),
//                isDefaultAction: true,
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//              )
//            ],
//          )
//      );
//    }

//    final buttonStyle = BoxDecoration(
//      border: Border.all(
//        color: Colors.grey,
//        width: 1.0,
//      )
//    );
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final topButtonPadding = screenHeight * 0.039;
    final bottomButtonPadding = screenHeight * 0.0234;
//    final buttonBorderColor = Border.all(color: Color.fromARGB(100, 191, 191, 191),width: 1);

    Widget _displayGridItem(String value, String imageUrl) {
      return new GestureDetector(
        onTap: () {
          debugPrint("Size Heigh of Screen: " + screenHeight.toString());
        },
        child: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                imageUrl,
              ),
              new Container(
                child: new Text(
                  value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,

                  ),
                ),
                margin: EdgeInsets.only(top: 26),
              )
            ],
          ),
        )
      );
    }
    
    Widget searchBar = new Container (
      height: 56.0,
      color: Colors.grey,
      child: Center(
        child: Container(
        width: screenWidth - 16.0,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0)
        ) ,
        child: GestureDetector(
          onTap: (){
          },
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Icon(
                    Icons.search,
                    color: Colors.grey
                ),
              ),
              new Text(
                "SearchBar",
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: screenWidth - 190),
                width: 40,
                height: 40,
                child: InkWell(
                  child: Image.asset(
                    'assets/qrCodeGrey.png',
                  ),
                  onTap: (){
                    debugPrint('QRCode Pressed');
                  },
                ),
              ),
            ],
          ),
        )
      ),
      )
    );


    Widget loginBt = Padding(
        padding: EdgeInsets.all(16),
        child: GestureDetector(
            child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    "Log In",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white
                    ),
                  ),
                )
            ),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginV()),
            );
          },
        )

    );

    return Scaffold (
      body: new Container(
//        height: MediaQuery.of(context).size.height,
//        color: Colors.redAccent,
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            searchBar,
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
//                    decoration: BoxDecoration(
//                      border: buttonBorderColor,
//                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: topButtonPadding, bottom:bottomButtonPadding),
                      child: _displayGridItem("Article Identification\nService",'assets/article-identification.png'),
                    ),
                  )
                ),
                Container(
                  color: Color.fromARGB(100, 191, 191, 191),
                  width: 1,
                ),
                Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Color.fromARGB(100, 191, 191, 191),width: 1)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: topButtonPadding, bottom:bottomButtonPadding),
                        child: _displayGridItem("Article Bookmark\nList",'assets/document-list-green.png'),
                      ),
                    ),
                ),
              ],
            ),
            Container(
              color: Color.fromARGB(100, 191, 191, 191),
              height: 1,
              width: screenWidth,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Container(
//                      decoration: BoxDecoration(
//                        border: Border(left: BorderSide(color: Color.fromARGB(100, 191, 191, 191),width: 1)),
//                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: topButtonPadding, bottom:bottomButtonPadding),
                        child: _displayGridItem("Project\nDocumentation",'assets/documentGrey.png'),
                      ),
                    )
                ),
                Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Color.fromARGB(100, 191, 191, 191),width: 1)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: topButtonPadding, bottom:bottomButtonPadding),
                        child: _displayGridItem("Docu Center \n",'assets/docucenter.png'),
                      ),
                    ),
                  flex: 1,
                ),
              ],
            ),
            Container(
              color: Color.fromARGB(100, 191, 191, 191),
              height: 1,
              width: screenWidth,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Container(
//                      decoration: BoxDecoration(
//                        border: buttonBorderColor,
//                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: topButtonPadding, bottom:bottomButtonPadding),
                        child: _displayGridItem("Company profile\n",'assets/buildingGreenHome.png'),
                      ),
                    )
                ),
                Container(
                  color: Color.fromARGB(100, 191, 191, 191),
                  width: 1,
                ),
                Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Color.fromARGB(100, 191, 191, 191),width: 1)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: topButtonPadding, bottom:bottomButtonPadding),
                        child: _displayGridItem("Service / FAQ\n",'assets/informationGreen.png'),
                      ),
                    )
                ),
              ],
            ),
            Container(
              color: Color.fromARGB(100, 191, 191, 191),
              height: 1,
              width: screenWidth,
            ),
            loginBt
          ],
        ),
      )
    );
  }

}