import 'dart:math';
import 'dart:ui';

double distance(Offset point1, Offset point2) {
  final x = point1.dx - point2.dx;
  final y = point1.dy - point2.dy;
  return sqrt(pow(x, 2) + pow(y, 2));
}

Offset centerPoint(Offset point1, Offset point2) =>
    Offset((point1.dx + point2.dx) / 2, (point1.dy + point2.dy) / 2);

double horizontalAngle(Offset point1, Offset point2) {
  final atanAngle = atan2(point1.dy - point2.dy, point1.dx - point2.dx);
  if (atanAngle > pi / 2) return atanAngle - pi; //weird
  if (atanAngle < -(pi / 2)) return (pi + atanAngle);
  return atanAngle;
}

double getAngle(Offset point1, Offset point2, Offset point3) {
  if (point1 == null || point2 == null || point3 == null) return 180;
  final angle1 = atan2(point1.dy - point2.dy, point1.dx - point2.dx);
  final angle2 = atan2(point2.dy - point3.dy, point2.dx - point3.dx);
  final result = (angle1 - angle2) * 180 / pi;
  final result2 = result < 0 ? result + 360 : result;
  return (180 - result2).abs();
}

//pi / 2 = 90
//pi = 180
