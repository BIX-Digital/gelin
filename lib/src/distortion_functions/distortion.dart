import 'dart:math';

import '../models/graphic_objects.dart';


// This is distortion function example
AdjustableCurve2D simpleDistortionFunc(AdjustableCurve2D curve, {int pointsToDistort = 2}) {
  // Let's distort points in the line
  if (curve.coordinates.length < pointsToDistort) {
    throw Exception("Line length should be bigger then $pointsToDistort");
  }
  var distortionStartPoint = Random().nextInt(curve.coordinates.length - pointsToDistort);
  for (var i = distortionStartPoint;
  i < distortionStartPoint + pointsToDistort;
  i++) {
    // Use std to find axis to distort coordinates
    // if std X is bigger - distort Y and vice versa
    List coordStd = curve.getCoordinatesStd();
    if (coordStd[0] < coordStd[1]) {
      var x = curve.coordinates[i].x + 10;
      curve.coordinates[i] = Coord(x, curve.coordinates[i].y);
    } else {
      var y = curve.coordinates[i].y + 10;
      curve.coordinates[i] = Coord(curve.coordinates[i].x, y);
    }

  }
  return curve;
}