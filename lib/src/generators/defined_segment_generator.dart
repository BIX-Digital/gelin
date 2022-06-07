import 'package:scidart/numdart.dart';

import 'curves_generator.dart';
import '../models/graphic_objects.dart';

class RandomCurvesInDefinedSegmentGenerator extends CurvesGenerator {
  final Segment segment;

  RandomCurvesInDefinedSegmentGenerator(
      {required double minEnd,
        required double maxEnd,
        required this.segment,
        int pointsAmount = 20})
      : super(minEnd: minEnd, maxEnd: maxEnd, pointsAmount: pointsAmount);

  // Custom constructor allows to get fully randomized positions within
  // a specified segment. Curve length can be modified specifing lineLenght
  // argument. Amount of points in the curve can be changed with pointsAmount arg.
  RandomCurvesInDefinedSegmentGenerator.randomized(
      {required this.segment, super.pointsAmount, super.lineLength})
      : super.randomized();

  @override
  AdjustableCurve2D generate(DistortionFunc? func,
      {int pointsToDistort = 2, bool distort = false, bool rotate = false}) {
    // horizontal or vertical line
    String spacePosition = getRandomSpacePosition();
    List<Array> line = getLine(spacePosition);
    var xLine = line[0];
    var yLine = line[1];
    if (func != null && distort == true) {
      yLine = func(yLine, pointsToDistort: pointsToDistort);
    }
    return AdjustableCurve2D(xLine, yLine);
  }

  List<Array> getLine(String spacePosition) {
    // if segment is top left and position horizontal then our line is positive X
    // if segment is top left and position vertical then our line is positive Y
    // if segment is bottom left and position horizontal then our line is positive X
    // if segment is bottom left and position vertical then our line is negative Y
    // if segment is bottom right and position horizontal then our line is negative X
    // if segment is bottom right position vertical then our line is negative Y
    // if segment is top right and position horizontal then our line is negative X
    // if segment is top right and position vertical then our line is positive Y
    Array x;
    Array y;
    if (spacePosition == 'horizontal') {
      switch (segment) {
        case Segment.topRight:
          x = linspace(minEnd, maxEnd, num: pointsAmount);
          var yPos = getPosition(min: 0, max: maxAngle.toInt());
          y = generateUniformlyFilledArray(pointsAmount, fillValue: yPos);
          break;
        case Segment.bottomRight:
          x = linspace(minEnd, maxEnd, num: pointsAmount);
          var yPos = getPosition(min: -maxAngle.toInt(), max: 0);
          y = generateUniformlyFilledArray(pointsAmount, fillValue: yPos);
          break;
        case Segment.bottomLeft:
          x = linspace(-maxEnd, -minEnd, num: pointsAmount);
          var yPos = getPosition(min: -maxAngle.toInt(), max: 0);
          y = generateUniformlyFilledArray(pointsAmount, fillValue: yPos);
          break;
        default: // topLeft
          x = linspace(-maxEnd, -minEnd, num: pointsAmount);
          var yPos = getPosition(min: 0, max: maxAngle.toInt());
          y = generateUniformlyFilledArray(pointsAmount, fillValue: yPos);
      }
    } else {
      switch (segment) {
        case Segment.topRight:
          y = linspace(minEnd, maxEnd, num: pointsAmount);
          var xPos = getPosition(min: 0, max: maxAngle.toInt());
          x = generateUniformlyFilledArray(pointsAmount, fillValue: xPos);
          break;
        case Segment.bottomRight:
          y = linspace(-maxEnd, -minEnd, num: pointsAmount);
          var xPos = getPosition(min: 0, max: maxAngle.toInt());
          x = generateUniformlyFilledArray(pointsAmount, fillValue: xPos);
          break;
        case Segment.bottomLeft:
          y = linspace(-maxEnd, -minEnd, num: pointsAmount);
          var xPos = getPosition(min: -maxAngle.toInt(), max: 0);
          x = generateUniformlyFilledArray(pointsAmount, fillValue: xPos);
          break;
        default: // topLeft
          y = linspace(minEnd, maxEnd, num: pointsAmount);
          var xPos = getPosition(min: -maxAngle.toInt(), max: 0);
          x = generateUniformlyFilledArray(pointsAmount, fillValue: xPos);
      }
    }
    return [x, y];
  }
}
