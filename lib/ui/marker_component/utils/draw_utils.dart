import 'dart:math';
import 'dart:ui';

import 'package:meta/meta.dart';

drawArrow({
  double arrowAngle = 50,
  double arrowRadius = 10,
  @required Offset startPoint,
  @required Offset endPoint,
  @required Canvas canvas,
  @required Paint paint,
  bool drawStart = false,
  bool drawEnd = false,
}) {
  final angleRad = pi * arrowAngle / 180.0;

  if (drawEnd) {
    final lineAngle = atan2(
      endPoint.dy - startPoint.dy,
      endPoint.dx - startPoint.dx,
    );
    final path = _arrowPath(
      point: endPoint,
      radius: arrowRadius,
      angleRad: angleRad,
      lineAngle: lineAngle,
    );
    canvas.drawPath(
      path,
      paint,
    );
  }

  if (drawStart) {
    final lineAngle = atan2(
      startPoint.dy - endPoint.dy,
      startPoint.dx - endPoint.dx,
    );
    final path = _arrowPath(
      point: startPoint,
      radius: arrowRadius,
      angleRad: angleRad,
      lineAngle: lineAngle,
    );
    canvas.drawPath(
      path,
      paint,
    );
  }
}

Path _arrowPath({
  @required Offset point,
  @required double radius,
  @required double angleRad,
  @required double lineAngle,
}) =>
    Path()
      ..fillType = PathFillType.evenOdd
      ..moveTo(point.dx, point.dy)
      ..lineTo(
        point.dx - radius * cos(lineAngle - angleRad / 2.0),
        point.dy - radius * sin(lineAngle - angleRad / 2.0),
      )
      ..lineTo(
        point.dx - radius * cos(lineAngle + angleRad / 2.0),
        point.dy - radius * sin(lineAngle + angleRad / 2.0),
      )
      ..close();

drawText({
  @required String text,
  @required Offset point,
  @required Canvas canvas,
  @required Color color,
  double rotation = 0,
  double maxOffset = 20,
}) {
  if (text.isEmpty) return;

  final textX = point.dx - 15;
  final textY = point.dy - maxOffset;

  final paragraphBuilder = ParagraphBuilder(
    ParagraphStyle(fontSize: 14, textAlign: TextAlign.start),
  )
    ..addText(text)
    ..pushStyle(TextStyle(color: color));

  final paragraph = paragraphBuilder.build();
  paragraph.layout(ParagraphConstraints(width: 100));

  canvas.save();
  canvas.translate(textX, textY);

  canvas.rotate(rotation);

  canvas.drawParagraph(
    paragraph,
    Offset(0, 0),
  );

  canvas.restore();
}
