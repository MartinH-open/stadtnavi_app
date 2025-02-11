import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:vector_tile/vector_tile.dart';

import 'citybikes_enum.dart';

class CityBikeFeature {
  final GeoJsonPoint geoJsonPoint;
  final String id;
  final CityBikeLayerIds type;

  final LatLng position;
  CityBikeFeature({
    @required this.geoJsonPoint,
    @required this.id,
    @required this.type,
    @required this.position,
  });
  // ignore: prefer_constructors_over_static_methods
  static CityBikeFeature fromGeoJsonPoint(GeoJsonPoint geoJsonPoint) {
    String id;
    CityBikeLayerIds type;
    for (final element in geoJsonPoint.properties) {
      switch (element.keys.first) {
        case "id":
          id = element.values.first.dartStringValue;
          break;
        case "networks":
          type = cityBikeLayerIdStringToEnum(
            element.values.first.dartStringValue,
          );
          break;
        default:
      }
    }
    return CityBikeFeature(
      geoJsonPoint: geoJsonPoint,
      id: id,
      type: type,
      position: LatLng(
        geoJsonPoint.geometry.coordinates[1],
        geoJsonPoint.geometry.coordinates[0],
      ),
    );
  }
}
