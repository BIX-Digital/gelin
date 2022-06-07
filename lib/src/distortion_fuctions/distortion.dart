import 'dart:math';

import 'package:scidart/numdart.dart';


// This is distortion function example
Array simpleDistortionFunc(Array line, {int pointsToDistort = 2}) {
  // Let's distort points in the line
  if (line.length < pointsToDistort) {
    throw Exception("Line length should be bigger then $pointsToDistort");
  }
  var distortionStartPoint = Random().nextInt(line.length - pointsToDistort);
  for (var i = distortionStartPoint;
  i < distortionStartPoint + pointsToDistort;
  i++) {
    // line[i] = -pow((1 * line[i]), 2) + line[i] / 2;
    line[i] = line[i] + 0.10;
  }
  return line;
}