import 'dart:math';

import 'package:scidart/numdart.dart';


import '../models/graphic_objects.dart';
import 'curves_generator.dart';

class RandomCurvesInRandomSegmentGenerator extends CurvesGenerator {
  late final Array _line;

  RandomCurvesInRandomSegmentGenerator(
      {required double minEnd, required double maxEnd, int pointsAmount = 20})
      : super(minEnd: minEnd, maxEnd: maxEnd, pointsAmount: pointsAmount) {
    // Generate line for the test and then we will apply distortion
    // to one of them
    _line = linspace(minEnd, maxEnd, num: pointsAmount);
  }

  RandomCurvesInRandomSegmentGenerator.randomized({int pointsAmount = 20})
      : super.randomized(pointsAmount: pointsAmount) {
    // Randomly change sign
    if (Random().nextDouble() > 0.5) {
      var tmp = minEnd * -1;
      minEnd = maxEnd * -1;
      maxEnd = tmp;
    }

    _line = linspace(minEnd, maxEnd, num: pointsAmount);
  }

  // Curves (and Lines) generator
  AdjustableCurve2D generateHorizontal(DistortionFunc? func,
      {double yPosition = 0.2,
        int pointsToDistort = 2,
        bool distort = false,
        bool rotate = false}) {
    // Code will generate 2 lines (curves) in 2D space. Because initially they
    // are parallel to the X axis variables are named with upper and lower
    // words in them.
    var xLine = _line.copy();
    var yLine =
    generateUniformlyFilledArray(_line.length, fillValue: yPosition);
    if (func != null && distort == true) {
      yLine = func(yLine, pointsToDistort: pointsToDistort);
    }
    return AdjustableCurve2D(xLine, yLine);
  }

  AdjustableCurve2D generateVertical(DistortionFunc? func,
      {double xPosition = 0.2,
        int pointsToDistort = 2,
        bool distort = false,
        bool rotate = false}) {
    var yLine = _line.copy();
    var xLine =
    generateUniformlyFilledArray(_line.length, fillValue: xPosition);
    if (func != null && distort == true) {
      xLine = func(xLine, pointsToDistort: pointsToDistort);
    }
    return AdjustableCurve2D(xLine, yLine);
  }

  @override
  AdjustableCurve2D generate(
      DistortionFunc? func, {
        int pointsToDistort = 2,
        bool distort = false,
        bool rotate = false,
      }) {
    AdjustableCurve2D curve;
    double position = getPosition();
    String choice = getRandomSpacePosition();

    if (choice == 'vertical') {
      curve = generateVertical(func,
          xPosition: position,
          pointsToDistort: pointsToDistort,
          distort: distort,
          rotate: rotate);
    } else {
      curve = generateHorizontal(func,
          yPosition: position,
          pointsToDistort: pointsToDistort,
          distort: distort,
          rotate: rotate);
    }
    if (rotate) {
      curve.rotate();
    }
    return curve;
  }
}
