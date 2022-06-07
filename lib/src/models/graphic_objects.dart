import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gelin/styles/colors.dart';
import 'package:scidart/numdart.dart';

class Coord {
  final double x, y;

  Coord(this.x, this.y) {
    // print('Created coordinate with x: $x and y: $y');
  }

  @override
  String toString() {
    return "Coord(x: $x, y: $y)";
  }

  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
  };
}

// The main class for representing curves and lines in the 2D space
class AdjustableCurve2D {
  late final List<Coord> coordinates;

  AdjustableCurve2D(Array x, Array y) {
    if (x.length != y.length) {
      throw Exception("Coordinates arrays length should be equal.");
    }
    coordinates = [];
    for (var i = 0; i < x.length; i++) {
      coordinates.add(Coord(x[i], y[i]));
    }
  }

  // Rotates curves
  rotate({double rot = pi * 2 / 3}) {
    for (var i = 0; i < coordinates.length; i++) {
      var coord = coordinates[i];
      var xRot = coord.x * cos(rot) + coord.y * sin(rot);
      var yRot = -coord.x * sin(rot) + coord.y * cos(rot);
      coordinates[i] = Coord(xRot, yRot);
    }
  }

  @override
  String toString() {
    return "AdjustableCurve2D(coordinates: $coordinates)";
  }

  Map<String, dynamic> toJson() {
    List<double> x = [];
    List<double> y = [];
    for (var c in coordinates) {
      x.add(c.x);
      y.add(c.y);
    }
    return {
      'x': x,
      'y': y,
    };
  }
}

// Get random int from a range
getRandomInt({int min = -6, int max = 6}) {
  var r = Random().nextInt((max - min).abs()) + min;
  // print("Random value: $r for min: $min and max: $max.");
  return r;
}

class Circle {
  final String shape = 'circle';
  final double radius;
  final charts.Color color;
  final double center;

  Circle(
      {this.radius = 6.0,
        this.color = CustomColors.circleColor,
        this.center = 0});
}
