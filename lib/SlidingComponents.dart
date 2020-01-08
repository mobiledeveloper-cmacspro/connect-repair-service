import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class SlidingComponents extends StatefulWidget {
  final String components;

  SlidingComponents(this.components);
  @override
  State<StatefulWidget> createState() {
    return SlidingComponentsState(this.components);
  }
}
class SlidingComponentsState extends State<SlidingComponents>{
  String components;
  SlidingComponentsState(this.components);

  List <Component> componentsList = [];

  bool filled = false;

  _fillComponets() {
    componentsList = [
      Component(FlutterI18n.translate(context, 'Roller carriage (front/rear)'),false) ,
      Component(FlutterI18n.translate(context, 'Top stays (front/rear)'),false),
      Component(FlutterI18n.translate(context, 'Corner drive (bottom, handle side)'),false),
      Component(FlutterI18n.translate(context, 'Corner drive (top, handle side)'),false),
      Component(FlutterI18n.translate(context, 'Corner drive (rear)'),false),
      Component(FlutterI18n.translate(context, 'Control device'),false),
      Component(FlutterI18n.translate(context, 'Handle'),false),
      Component(FlutterI18n.translate(context, 'Other'),false)];
  }
  _checkSelectedComponents(){
    if(components != null){
      for (String component in components.split(';')){
        for (Component comp in componentsList){
          if (component == comp.component){
            comp.selected = true;
          }
        }
      }
    }
  }
  Widget _checkImage() {
    if (filled) {
      return Image.asset(
        'assets/checkGreen.png',
        height: 25,
      );
    }
    else {
      return Image.asset(
        'assets/checkGrey.png',
        height: 25,
      );
    }
  }

  _selectedImage(bool selected){
    if(selected) {
      return Image.asset(
        'assets/checkGreen.png',
        height: 25,
      );
    }
    else {
      return Container();
    }
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _fillComponets();
    _checkSelectedComponents();
  }

  _saveComponents(){
    String comp = '';
    for (Component component in componentsList){
      if (component.selected) {
        if (comp == ''){
          comp = FlutterI18n.translate(context, component.component);
        }
        else {
          comp += ';${FlutterI18n.translate(context, component.component)}';
        }
      }
    }
    Navigator.pop(context,comp);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(FlutterI18n.translate(context, 'Fittings components to be replaced'),style: Theme.of(context).textTheme.body1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context,components);
          },
          color: Theme.of(context).primaryColor,
        ),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                if (filled) {
                  _saveComponents();
                }
              },
              child: _checkImage()
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: componentsList.length,
        itemBuilder: (BuildContext context, int index){
          return Column(
            children: <Widget>[
              Container(
                height: 44,
                child: GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                       child: Padding(
                         padding: EdgeInsets.only(left: 16),
                         child: Text(componentsList[index].component,style: Theme.of(context).textTheme.body1),
                       ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: _selectedImage(componentsList[index].selected)
                      )
                    ],
                  ),
                  onTap: (){
                    setState(() {
                      this.filled = true;
                      componentsList[index].selected = !componentsList[index].selected;
                    });
                  },
                ),
              ),
              Divider(height: 1)
            ],
          );
        },
      ),
    );
  }
}
class Component{
  String component;
  bool selected;
  Component(this.component,this.selected);
}