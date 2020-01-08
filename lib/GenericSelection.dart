import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenericSelection extends StatelessWidget {
  final String title;
  final List<String> myOptions;
  GenericSelection(this.title,this.myOptions);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(title,style: Theme.of(context).textTheme.body1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
      ),
      body:  ListView.builder(
        itemCount: myOptions == null ? 0 : myOptions.length,
        itemBuilder: (BuildContext context, int index){
          return new GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child:  Padding(
                    padding: EdgeInsets.only(top:16,left:16),
                    child: Text(
                        myOptions[index],
                        style:  Theme.of(context).textTheme.body1
                    ),
                  )
                ),
                Divider(
                  height: 1,
                  color: Color.fromRGBO(191, 191, 191, 1.0),
                )
              ],
            ),
            onTap: () {
              Navigator.pop(context,myOptions[index]);
            },
          );
        },
        shrinkWrap: true,
      )
    );
  }

}