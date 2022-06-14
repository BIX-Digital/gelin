import 'package:flutter_test/flutter_test.dart';

import 'package:gelin/gelin.dart';
import 'package:scidart/numdart.dart';
import 'package:gelin/src/generators/arcmin_generator.dart';


void main() {
  test('Test getSegmentMaxLimits top right', () {
    final gen = ArcminGenerator();
    var limits = gen.getSegmentMaxLimits(Segment.topRight);
    expect(limits.length, 2);
    expect(limits[0], 360.0);
    expect(limits[1], 360.0);
  });

  test('Test getSegmentMaxLimits bottom right', () {
    final gen = ArcminGenerator();
    var limits = gen.getSegmentMaxLimits(Segment.bottomRight);
    expect(limits.length, 2);
    expect(limits[0], 360.0);
    expect(limits[1], -360.0);
  });

  test('Test getSegmentMaxLimits bottom left', () {
    final gen = ArcminGenerator();
    var limits = gen.getSegmentMaxLimits(Segment.bottomLeft);
    expect(limits.length, 2);
    expect(limits[0], -360.0);
    expect(limits[1], -360.0);
  });

  test('Test getSegmentMaxLimits top left', () {
    final gen = ArcminGenerator();
    var limits = gen.getSegmentMaxLimits(Segment.topLeft);
    expect(limits.length, 2);
    expect(limits[0], -360.0);
    expect(limits[1], 360.0);
  });

  test('Test generateCoordinates', () {
    final gen = ArcminGenerator();
    var line = gen.generateCoordinates(Array([2,1]), SpacePosition.horizontal, 25);
    expect(line[0].length, 13);
    expect(line[1].length, 13);
    expect(line[1].last, 1);
    // expect(limits[0], -240.0);
    // expect(limits[1], 240.0);
  });

  test('Test isLineIntersectingBorders not crossing horizontal', () {
    final gen = ArcminGenerator();
    List<Array> line = [
      Array([10, 20, 30,40, 50]),
      Array([1,1,1,1,1])
    ];
    var result = gen.isCurveIntersectingBorders(line);
    expect(result, false);
  });

  test('Test isLineIntersectingBorders crossing horizontal', () {
    final gen = ArcminGenerator();
    List<Array> line = [
      Array([10, 20, 30,40, 50, 100, 200, 300, 360]),
      Array([1,1,1,1,1, 1, 1, 1, 1])
    ];
    var result = gen.isCurveIntersectingBorders(line);
    expect(result, true);
  });

  test('Test isLineIntersectingBorders not crossing vertical', () {
    final gen = ArcminGenerator();
    List<Array> line = [
      Array([1,1,1,1,1]),
      Array([10, 20, 30,40, 50]),
    ];
    var result = gen.isCurveIntersectingBorders(line);
    expect(result, false);
  });

  test('Test isLineIntersectingBorders crossing vertical', () {
    final gen = ArcminGenerator();
    List<Array> line = [
      Array([1, 1, 1, 1, 1, 1, 1, 1, 1]),
      Array([10, 20, 30,40, 50, 100, 200, 300, 360]),
    ];
    var result = gen.isCurveIntersectingBorders(line);
    expect(result, true);
  });
}