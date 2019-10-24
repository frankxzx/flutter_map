import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:tuple/tuple.dart';

import 'dart:math' as math;

class ScreenPixelCrs extends Crs {
  @override
  final String code = 'CRS.SCREEN_PIXEL';

  @override
  final Projection projection = null;

  @override
  final Transformation transformation = null;

  ScreenPixelCrs() : super();

  /// Converts a point on the sphere surface (with a certain zoom) in a
  /// map point.
  @override
  CustomPoint latLngToPoint(LatLng latlng, double zoom) {
    return CustomPoint(latlng.latitude, latlng.longitude);
  }

  @override

  /// Converts a map point to the sphere coordinate (at a certain zoom).
  LatLng pointToLatLng(CustomPoint point, double zoom) {
    return LatLng(point.x, point.y);
  }

  @override
  // TODO: implement infinite
  bool get infinite => null;

  @override
  // TODO: implement wrapLat
  Tuple2<double, double> get wrapLat => null;

  @override
  // TODO: implement wrapLng
  Tuple2<double, double> get wrapLng => null;
}
