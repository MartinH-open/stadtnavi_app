import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:stadtnavi_app/custom_layers/static_layer.dart';
import 'package:stadtnavi_app/custom_layers/widget/marker_modal.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/custom_layer.dart';
import 'package:vector_tile/vector_tile.dart';

import 'citybike_feature_model.dart';
import 'citybike_marker_modal.dart';
import 'citybikes_enum.dart';

class CityBikesLayer extends CustomLayer {
  final Map<String, CityBikeFeature> _pbfMarkers = {};

  CityBikesLayer(String layerId) : super(layerId);
  void addMarker(CityBikeFeature pointFeature) {
    if (_pbfMarkers[pointFeature.id] == null) {
      _pbfMarkers[pointFeature.id] = pointFeature;
      refresh();
    }
  }

  @override
  LayerOptions buildLayerOptions(int zoom) {
    double markerSize;
    switch (zoom) {
      case 13:
        markerSize = 5;
        break;
      case 14:
        markerSize = 10;
        break;
      case 15:
        markerSize = 15;
        break;
      case 16:
        markerSize = 20;
        break;
      case 17:
        markerSize = 25;
        break;
      case 18:
        markerSize = 30;
        break;
      default:
        markerSize = zoom != null && zoom > 18 ? 35 : null;
    }
    final markersList = _pbfMarkers.values.toList();
    // avoid vertical wrong overlapping
    markersList.sort(
      (b, a) => a.position.latitude.compareTo(b.position.latitude),
    );
    return MarkerLayerOptions(
      markers: markerSize != null
          ? markersList
              .map((element) => Marker(
                    height: markerSize + 5,
                    width: markerSize + 5,
                    point: element.position,
                    anchorPos: AnchorPos.align(AnchorAlign.top),
                    builder: (context) => GestureDetector(
                      onTap: () {
                        showBottomMarkerModal(
                          context: context,
                          builder: (BuildContext context) =>
                              CitybikeMarkerModal(
                            element: element,
                          ),
                        );
                      },
                      child: element.type.imageStop,
                    ),
                  ))
              .toList()
          : [],
    );
  }

  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: "https",
      host: "api.dev.stadtnavi.eu",
      path: "/routing/v1/router/vectorTiles/citybikes/$z/$x/$y.pbf",
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
        "Server Error on fetchPBF $uri with ${response.statusCode}",
      );
    }
    final bodyByte = response.bodyBytes;
    final tile = await VectorTile.fromByte(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();

        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);
          final CityBikeFeature pointFeature =
              CityBikeFeature.fromGeoJsonPoint(geojson);
          citybikeLayer?.addMarker(pointFeature);
        } else {
          throw Exception("Should never happened, Feature is not a point");
        }
      }
    }
  }

  @override
  String name(BuildContext context) {
    final localeName = TrufiLocalization.of(context).localeName;
    return localeName == "en"
        ? "Car, Bike & Cargo bike sharing"
        : "Carsharing & Fahrrad- / Lastenradverleih";
  }

  @override
  Widget icon(BuildContext context) {
    return const Icon(
      Icons.bike_scooter,
      color: Color.fromRGBO(255, 131, 74, 1),
    );
  }
}
