import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

import '../generators/curves_generator.dart';
import '../distortion_functions/distortion.dart';
import '../models/graphic_objects.dart';
import '../../styles/colors.dart';

class CurvesPlotter {
  // For debugging purposes curves can be drawn
  Widget plot(
      {DistortionFunc func = simpleDistortionFunc,
        int pointsToDistort = 2,
        bool distort = false,
        required CurvesGenerator curvesGenerator}) {
    AdjustableCurve2D curve = curvesGenerator.generate(func,
        pointsToDistort: pointsToDistort, distort: distort);

    var seriesDistorted = Series<Coord, double>(
      id: 'Distorted curve',
      domainFn: (Coord coord, _) => coord.x,
      measureFn: (Coord coord, _) => coord.y,
      radiusPxFn: (Coord coord, _) => 1.5,
      colorFn: (Coord coord, _) => CustomColors.lineColor,
      data: curve.coordinates,
    );

    var circles = [Circle()];
    var seriesCircle = Series<Circle, double>(
      id: 'Circle',
      domainFn: (Circle circle, _) => circle.center,
      measureFn: (Circle circle, _) => 0,
      radiusPxFn: (Circle circle, _) => circle.radius * 60,
      colorFn: (Circle circle, _) => circle.color,
      data: circles,
      fillColorFn: (Circle circle, _) => CustomColors.transparent,
      strokeWidthPxFn: (Circle circle, _) => 2,
    ); // Accessor function that associates each datum with a symbol renderer.
    // ..setAttribute(
    //     pointSymbolRendererFnKey, (int index) => circles[index].shape);

    return ScatterPlotChart(
      [seriesCircle, seriesDistorted],
      animate: true,
      domainAxis: const NumericAxisSpec(
        // viewport: NumericExtents(-6.0, 6.0),
        tickProviderSpec: BasicNumericTickProviderSpec(
          // Vertical axis every 2 ticks from 0 to 10
            dataIsInWholeNumbers: true,
            // zeroBound: false,
            desiredTickCount: 7),
      ),
      primaryMeasureAxis: const NumericAxisSpec(
          tickProviderSpec: BasicNumericTickProviderSpec(desiredTickCount: 7)),
    );
  }
}
