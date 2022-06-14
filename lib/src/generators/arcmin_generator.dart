import 'dart:math';

import 'package:logger/logger.dart';
import 'package:quiver/iterables.dart';
import 'package:scidart/numdart.dart';

import '../models/graphic_objects.dart';



class ArcminGenerator {
  var logger = Logger();
  // Describes the radius or the circle which defines test area
  final double arcminMax;
  // Because the generated curve / line has length which depends on distance
  // between points we define here max length limit
  late final double  maxCurveLength;
  // Curves / lines will be generated in two positions
  final List<SpacePosition> positionChoices = [SpacePosition.horizontal, SpacePosition.vertical];
  // We divide test area on 4 segments
  final List<Segment> segments = [Segment.topRight, Segment.bottomRight,
    Segment.bottomLeft, Segment.topLeft];
  // Class generates line / curve in a random way and sometimes generated line
  // does not fit required area, this mean that line will be generated until it
  // fits required area. For this purpose we have generation attempts constraint.
  int generationAttemntsLimit;

  /// max segment radius is 360 arcmin by default
  /// max line / curve length is 240 arcmin
  ArcminGenerator({this.arcminMax = 360, maxCurveLength = 300, this.generationAttemntsLimit = 1000}) {
    if (maxCurveLength >= arcminMax) {
      // Assume it is possible to fit lines or curves which are longer then area circle
      // radius (generated line must be less than 2 * R), however it makes line / curve generation
      // expensive, that's why we constrain max curve length here to less than radius.
      throw Exception('Line length should be less then area radius.');
    }
    // Extend maximal line length on 5 %
    this.maxCurveLength = maxCurveLength * 1.05;
  }


  /// Returns array of 2 elements with appropriate signs which represent segment
  /// borders in arcmins.
  Array getSegmentMaxLimits(Segment segment) {
    List<double> limit = List<double>.filled(2, arcminMax, growable: false);
    Array segmentLimits;
    switch(segment) {
      case Segment.topRight:
        segmentLimits = Array([1,1]) * Array(limit);
        break;
      case Segment.bottomRight:
        segmentLimits = Array([1,-1]) * Array(limit);
        break;
      case Segment.bottomLeft:
        segmentLimits = Array([-1,-1]) * Array(limit);
        break;
      default:
        // TOP LEFT SEGMENT
        segmentLimits = Array([-1,1]) * Array(limit);
    }
    return segmentLimits;
  }

  AdjustableCurve2D generate(
      double distanceBetweenPoints,
      DistortionFunc? func, {
        int pointsToDistort = 2,
        bool distort = false,
        bool rotate = false,
      }) {
    checkGenerationPreconditions(distanceBetweenPoints);
    var randomCurve =  generateRandomCurve(distanceBetweenPoints);
    if (func != null && distort) {
      randomCurve = func(randomCurve);
    }
    return randomCurve;
  }

  void checkGenerationPreconditions(double distanceBetweenPoints) {
    if ((distanceBetweenPoints < 12) && (distanceBetweenPoints > 120)) {
      throw Exception('Distance between points should be in space [12, 120]');
    }
    if (maxCurveLength / distanceBetweenPoints < 3) {
      throw Exception('There is no enough length to build a line. At least 3 points required.');
    }
  }

  AdjustableCurve2D generateRandomCurve(double distanceBetweenPoints) {
      var segment = getRandomSegment();
      var spacePosition = getRandomSpacePosition();
      return generateCurve(distanceBetweenPoints, segment, spacePosition);
  }

  AdjustableCurve2D generateCurve(double distanceBetweenPoints, Segment segment, SpacePosition spacePosition) {
    for(var i=0; i < generationAttemntsLimit; i++) {
      Array startPoint = getRandomStartPoint(segment);
      List<Array> coordinates = generateCoordinates(startPoint, spacePosition, distanceBetweenPoints);
      if (!isCurveIntersectingBorders(coordinates)) {
        logger.d('Line generated in ${i+1} attempts/-s');
        return AdjustableCurve2D(coordinates[0], coordinates[1]);
      }
    }
    logger.d('Problems with random line generation. Returning dummy line.');
    return generateDummyCurve(distanceBetweenPoints);
  }

  // Randomly generates line`s starting point within a specified segment
  Array getRandomStartPoint(Segment segment) {
    Array limits = getSegmentMaxLimits(segment);
    var random = Random();
    var x = random.nextDouble() * limits[0];
    var y = random.nextDouble() * limits[1];
    return Array([x, y]);
  }

  // Randomly generated line / curve is checked regarding this condition
  bool isCurveIntersectingBorders(List<Array> coordinates) {
    // The distance from all points to the center should be less then test area radius
    var points = zip([coordinates[0], coordinates[1]]).toList();
    // logger.d(points);
    return points.any((el) => sqrt(pow(el[0], 2) + pow(el[1], 2)) >= arcminMax);
  }

  // Randomly returns space position: horizontal or vertical
  SpacePosition getRandomSpacePosition() {
    int index = Random().nextInt(positionChoices.length);
    return positionChoices[index];
  }

  Segment getRandomSegment() {
    int index = Random().nextInt(segments.length);
    return segments[index];
  }

  // Generates line coordinates based on start point and distance between points
  List<Array> generateCoordinates(Array startPoint, SpacePosition spacePosition, double distanceBetweenPoints) {
    var sign = getRandomSign();
    var pointsX = Array([startPoint[0]]);
    var pointsY = Array([startPoint[1]]);
    var pointsToGenerate = maxCurveLength ~/ distanceBetweenPoints;
    if (spacePosition == SpacePosition.horizontal) {
      // Y coordinates should be mutually equal
      for (var i=0; i < pointsToGenerate; i++) {
        var nextPointX = pointsX.last + distanceBetweenPoints * sign;
        pointsX.add(nextPointX);
        pointsY.add(pointsY.last);
      }
    } else {
      // X coordinates should be mutually equal
      for (var i=0; i < pointsToGenerate; i++) {
        var nextPointY = pointsY.last + distanceBetweenPoints * sign;
        pointsY.add(nextPointY);
        pointsX.add(pointsX.last);
      }
    }
    // logger.d([pointsX, pointsY]);
    return [pointsX, pointsY];
  }

  int getRandomSign() {
    var signs = [-1, 1];
    var idx = Random().nextInt(signs.length);
    return signs[idx];
  }

  AdjustableCurve2D generateDummyCurve(double distanceBetweenPoints) {
    /// Assuming all checks are done in a calling method
    /// distance between points is less than max line length and segment length
    /// (area radius)
    var startPoint = Array([0, 0]);
    var coordinates = generateCoordinates(startPoint, SpacePosition.horizontal, distanceBetweenPoints);
    return AdjustableCurve2D(coordinates[0], coordinates[1]);
  }
}