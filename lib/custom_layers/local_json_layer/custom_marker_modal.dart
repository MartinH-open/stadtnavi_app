import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_app/custom_layers/local_json_layer/custom_marker_model.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/widgets/custom_location_selector.dart';

class CustomMarkerModal extends StatelessWidget {
  final CustomMarker element;
  final void Function() onFetchPlan;
  const CustomMarkerModal({
    Key key,
    @required this.element,
    @required this.onFetchPlan,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = TrufiLocalization.of(context);
    final theme = Theme.of(context);
    final localeName = localization.localeName;
    String title;
    String body;
    if (localeName == "en") {
      title = element.nameEn ?? element.name ?? "";
      body = element.popupContentEn ?? element.popupContent ?? "";
    } else {
      title = element.nameDe ?? element.name ?? "";
      body = element.popupContentDe ?? element.popupContent ?? "";
    }
    // apply format to the popup content
    body = body.replaceAll(", ", "\n\n");
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
                child: SvgPicture.string(element.image),
              ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                body,
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
            title,
            "",
            element.position,
          ),
        ),
      ],
    );
  }
}
