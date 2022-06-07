import 'dart:math';

import 'package:scidart/numdart.dart';

import '../models/graphic_objects.dart';

// Distortion function type definition
typedef DistortionFunc = Array Function(Array line, {int pointsToDistort});

enum Segment { topLeft, bottomLeft, bottomRight, topRight }


extension ParseToString on Enum {
  String toShortString() {
    return toString().split('.').last;
  }
}

abstract class CurvesGenerator {
  final double maxAngle = 6.0;
  final double lineLength;
  // the most left number of numbers axis to be included
  late double minEnd;
  // the most right number of numbers axis to be included
  late double maxEnd;
  // amount of points in a curve / line
  late final int pointsAmount;
  final List<String> positionChoices = ['horizontal', 'vertical'];

  CurvesGenerator({
    required this.minEnd,
    required this.maxEnd,
    this.pointsAmount = 20,
    this.lineLength = 4.0,
  }) {
    if (minEnd >= maxAngle || maxEnd >= maxAngle || minEnd >= maxAngle) {
      throw Exception("Please verify <CurvesGenerator> constructor arguments");
    }
  }

  CurvesGenerator.randomized({
    this.pointsAmount = 20,
    this.lineLength = 4.0,
  }) {
    // get start coordinate. It should lie in range
    // less than [R - line length]
    minEnd = Random().nextDouble() * (maxAngle - lineLength);
    // get end coordinate
    maxEnd = minEnd + lineLength;
  }

  // Method which should be implemented in every inheriting class
  AdjustableCurve2D generate(
      DistortionFunc? func, {
        int pointsToDistort = 2,
        bool distort = false,
        bool rotate = false,
      });

  String getRandomSpacePosition() {
    int index = Random().nextInt(positionChoices.length);
    return positionChoices[index];
  }

  double getPosition({int min = -6, int max = 6}) {
    while (true) {
      int constraint = getRandomInt(min: min, max: max);
      double multiplier = Random().nextDouble();
      double position = constraint * multiplier;
      double distanceMin = sqrt(pow(minEnd, 2) + pow(position, 2));
      double distanceMax = sqrt(pow(maxEnd, 2) + pow(position, 2));
      if (distanceMin < maxAngle && distanceMax < maxAngle) {
        return position;
      }
    }
  }

  // generates unifurmly filled array like [0,0,0,0,0...]
  Array generateUniformlyFilledArray(int length, {double fillValue = 0}) {
    return Array(List<double>.filled(length, fillValue, growable: false));
  }
}
