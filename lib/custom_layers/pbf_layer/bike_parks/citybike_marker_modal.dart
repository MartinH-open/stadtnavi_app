import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trufi_core/widgets/custom_location_selector.dart';

import 'bike_park_feature_model.dart';
import 'bike_park_icons.dart';

class CitybikeMarkerModal extends StatelessWidget {
  final BikeParkFeature element;
  final void Function() onFetchPlan;
  const CitybikeMarkerModal({
    Key key,
    @required this.element,
    @required this.onFetchPlan,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SvgPicture.string(
                  parkingMarkerIcons[element.type] ?? "",
                ),
              ),
              Expanded(
                child: Text(
                  element.name ?? "",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (element.bicyclePlacesCapacity != null)
                Text(
                  "${element.bicyclePlacesCapacity} ${languageCode == 'en' ? 'parking spaces' : 'Stellplätze'}",
                  style: TextStyle(
                    color: theme.textTheme.bodyText1.color,
                  ),
                ),
            ],
          ),
        ),
        CustomLocationSelector(
          onFetchPlan: onFetchPlan,
          locationData: LocationDetail(
            element.name ?? "",
            "",
            element.position,
          ),
        ),
      ],
    );
  }
}
