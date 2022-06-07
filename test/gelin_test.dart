import 'package:flutter_test/flutter_test.dart';

import 'package:gelin/gelin.dart';
import 'package:gelin/src/generators/curves_generator.dart';

void main() {
  test('adds one to input values', () {
    final gen = RandomCurvesInDefinedSegmentGenerator(minEnd: 1,
        maxEnd: 4, segment: Segment.bottomLeft);
    var generatedLine = gen.generate((line, {pointsToDistort:2}) => line);
    // Default amount of points should be 20
    expect(generatedLine.coordinates.length, 20);
  });
}
