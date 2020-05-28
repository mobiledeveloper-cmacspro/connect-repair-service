import 'dart:math';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Arrow extends CustomPainter {
  Offset startPoint = Offset(0,0);
  Offset endPoint =  Offset(0,0);
  double tailWidth,headWidth,headLength;
  bool drawed = false;
  bool selected = false;
  Widget startCircle,endCircle;
  double measurement = 0;
  String unit;
  bool haveTwoHead = true;
  Color color = Color.fromRGBO(120, 185, 40, 1.0);

  Arrow(this.startPoint,this.endPoint,this.haveTwoHead);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = color;
    tailWidth = 4;
    headWidth = 10;
    headLength = 10;
    var x = startPoint.dx;
    var y = startPoint.dy - headWidth / 2 - 25;

    if (endPoint.dx < startPoint.dx) {
      x = endPoint.dx;
      y = endPoint.dy - headWidth / 2 - 25;
    }
    var centerArrow = Offset(0, 0);
    if(startPoint.dx <= endPoint.dx && startPoint.dy <= endPoint.dy) {
      centerArrow = Offset(x + (endPoint.dx - startPoint.dx).abs()/2, y + (endPoint.dy - startPoint.dy).abs()/2);
    }
    else if (startPoint.dx > endPoint.dx && startPoint.dy <= endPoint.dy) {
      centerArrow = Offset(x + (endPoint.dx - startPoint.dx).abs()/2,y - (endPoint.dy - startPoint.dy).abs()/2);
    }
    else if (startPoint.dx <= endPoint.dx && startPoint.dy > endPoint.dy) {
      centerArrow = Offset(x + (endPoint.dx - startPoint.dx).abs()/2, y - (endPoint.dy - startPoint.dy).abs()/2);
    }
    else if (startPoint.dx > endPoint.dx && startPoint.dy > endPoint.dy) {
      centerArrow = Offset(x + (endPoint.dx - startPoint.dx).abs()/2, y + (endPoint.dy - startPoint.dy).abs()/2);
    }

    final length = hypot(endPoint.dx - startPoint.dx, endPoint.dy - startPoint.dy) + 1;
    final tailLength = length - headLength * 2;
    List<Point> points = [];
    if (haveTwoHead){
      points = [
        Point(0, 0),
        Point(headLength, headWidth / 2),
        Point(headLength, tailWidth / 2),
        Point(headLength + tailLength, tailWidth/2),
        Point(headLength + tailLength, headWidth / 2),
        Point(length, 0),
        Point(tailLength + headLength, -headWidth / 2),
        Point(tailLength + headLength, -tailWidth / 2),
        Point(headLength, -tailWidth / 2),
        Point(headLength, -headWidth / 2)
      ];
    }
    else {
      points = [
        Point(0, tailWidth / 2),
        Point(tailLength, tailWidth / 2),
        Point(tailLength, headWidth / 2),
        Point(length, 0),
        Point(tailLength, -headWidth / 2),
        Point(tailLength, -tailWidth / 2),
        Point(0, -tailWidth / 2)
      ];
    }
//    final cosine = (endPoint.x - startPoint.x) / length;
//    final sine = (endPoint.y - startPoint.y) / length;
    var path = Path();
    path.moveTo(points[1].x, points[1].y);
    for (int i = 1; i < points.length;i++){
      path.lineTo(points[i].x, points[i].y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return null;
  }
  double hypot(double a, double b){
    double num = a*a + b*b;
    double h = 0.000001,raiz = h;
    while(raiz*raiz < num){
      raiz += h;
    }
    return raiz;
  }
}