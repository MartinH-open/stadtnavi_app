import 'alert.dart';
import 'cluster.dart';
import 'enums/mode.dart';
import 'enums/stop/location_type.dart';
import 'enums/stop/wheelchair_boarding.dart';
import 'pattern.dart';
import 'route.dart';
import 'stop_at_distance.dart';
import 'stoptime.dart';
import 'stoptimes_in_pattern.dart';

class Stop {
  final String id;
  final List<Stoptime> stopTimesForPattern;
  final String gtfsId;
  final String name;
  final double lat;
  final double lon;
  final String code;
  final String desc;
  final String zoneId;
  final String url;
  final LocationType locationType;
  final Stop parentStation;
  final WheelchairBoarding wheelchairBoarding;
  final String direction;
  final String timezone;
  final int vehicleType;
  final Mode vehicleMode;
  final String platformCode;
  final Cluster cluster;
  final List<Stop> stops;
  final List<RouteOtp> routes;
  final List<Pattern> patterns;
  final List<StopAtDistance> transfers;
  final List<StoptimesInPattern> stoptimesForServiceDate;
  final List<StoptimesInPattern> stoptimesForPatterns;
  final List<Stoptime> stoptimesWithoutPatterns;
  final List<Alert> alerts;

  const Stop({
    this.id,
    this.stopTimesForPattern,
    this.gtfsId,
    this.name,
    this.lat,
    this.lon,
    this.code,
    this.desc,
    this.zoneId,
    this.url,
    this.locationType,
    this.parentStation,
    this.wheelchairBoarding,
    this.direction,
    this.timezone,
    this.vehicleType,
    this.vehicleMode,
    this.platformCode,
    this.cluster,
    this.stops,
    this.routes,
    this.patterns,
    this.transfers,
    this.stoptimesForServiceDate,
    this.stoptimesForPatterns,
    this.stoptimesWithoutPatterns,
    this.alerts,
  });

  factory Stop.fromJson(Map<String, dynamic> json) => Stop(
        id: json['id'].toString(),
        stopTimesForPattern: json['stopTimesForPattern'] != null
            ? List<Stoptime>.from(
                (json["stopTimesForPattern"] as List<dynamic>).map(
                (x) => Stoptime.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        gtfsId: json['gtfsId'].toString(),
        name: json['name'].toString(),
        lat: double.tryParse(json['lat'].toString()) ?? 0,
        lon: double.tryParse(json['lon'].toString()) ?? 0,
        code: json['code'].toString(),
        desc: json['desc'].toString(),
        zoneId: json['zoneId'].toString(),
        url: json['url'].toString(),
        locationType: getLocationTypeByString(json['locationType'].toString()),
        parentStation: json['parentStation'] != null
            ? Stop.fromJson(json['parentStation'] as Map<String, dynamic>)
            : null,
        wheelchairBoarding: getWheelchairBoardingByString(
            json['wheelchairBoarding'].toString()),
        direction: json['direction'].toString(),
        timezone: json['timezone'].toString(),
        vehicleType: int.tryParse(json['vehicleType'].toString()) ?? 0,
        vehicleMode: getModeByString(json['vehicleMode'].toString()),
        platformCode: json['platformCode'].toString(),
        cluster: json['cluster'] != null
            ? Cluster.fromJson(json['cluster'] as Map<String, dynamic>)
            : null,
        stops: json['stops'] != null
            ? List<Stop>.from((json["stops"] as List<dynamic>).map(
                (x) => Stop.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        routes: json['routes'] != null
            ? List<RouteOtp>.from((json["routes"] as List<dynamic>).map(
                (x) => RouteOtp.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        patterns: json['patterns'] != null
            ? List<Pattern>.from((json["patterns"] as List<dynamic>).map(
                (x) => Pattern.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        transfers: json['transfers'] != null
            ? List<StopAtDistance>.from(
                (json["transfers"] as List<dynamic>).map(
                (x) => StopAtDistance.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        stoptimesForServiceDate: json['stoptimesForServiceDate'] != null
            ? List<StoptimesInPattern>.from(
                (json["stoptimesForServiceDate"] as List<dynamic>).map(
                (x) => StoptimesInPattern.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        stoptimesForPatterns: json['stoptimesForPatterns'] != null
            ? List<StoptimesInPattern>.from(
                (json["stoptimesForPatterns"] as List<dynamic>).map(
                (x) => StoptimesInPattern.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        stoptimesWithoutPatterns: json['stoptimesWithoutPatterns'] != null
            ? List<Stoptime>.from(
                (json["stoptimesWithoutPatterns"] as List<dynamic>).map(
                (x) => Stoptime.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        alerts: json['alerts'] != null
            ? List<Alert>.from((json["alerts"] as List<dynamic>).map(
                (x) => Alert.fromJson(x as Map<String, dynamic>),
              ))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'stopTimesForPattern': List.generate(stopTimesForPattern?.length ?? 0,
            (index) => stopTimesForPattern[index].toJson()),
        'gtfsId': gtfsId,
        'name': name,
        'lat': lat,
        'lon': lon,
        'code': code,
        'desc': desc,
        'zoneId': zoneId,
        'url': url,
        'locationType': locationType?.name,
        'parentStation': parentStation?.toJson(),
        'wheelchairBoarding': wheelchairBoarding?.name,
        'direction': direction,
        'timezone': timezone,
        'vehicleType': vehicleType,
        'vehicleMode': vehicleMode?.name,
        'platformCode': platformCode,
        'cluster': cluster?.toJson(),
        'stops': List<dynamic>.from(stops.map((x) => x.toJson())),
        'routes': List<dynamic>.from(routes.map((x) => x.toJson())),
        'patterns': List<dynamic>.from(patterns.map((x) => x.toJson())),
        'transfers': List<dynamic>.from(transfers.map((x) => x.toJson())),
        'stoptimesForServiceDate':
            List<dynamic>.from(stoptimesForServiceDate.map((x) => x.toJson())),
        'stoptimesForPatterns':
            List<dynamic>.from(stoptimesForPatterns.map((x) => x.toJson())),
        'stoptimesWithoutPatterns':
            List<dynamic>.from(stoptimesWithoutPatterns.map((x) => x.toJson())),
        'alerts': List<dynamic>.from(alerts.map((x) => x.toJson())),
      };

  List<Stoptime> get stoptimesWithoutPatternsCurrent {
    final now = DateTime.now();
    return stoptimesWithoutPatterns
        .where((element) => element.stopTime.isAfter(now))
        .where((element) =>
            element.stopTime.isBefore(now.add(const Duration(days: 1))))
        .toList();
  }
}
