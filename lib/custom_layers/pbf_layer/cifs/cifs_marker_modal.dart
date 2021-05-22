import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cifs_feature_model.dart';
import 'cifs_icons.dart';

class CifsMarkerModal extends StatelessWidget {
  final CifsFeature element;
  const CifsMarkerModal({Key key, @required this.element}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String startTime = element.starttime != null
        ? DateFormat("MMM d, yyyy").format(DateTime.parse(element.starttime))
        : "";
    final String endTime = element.endtime != null
        ? DateFormat("MMM d, yyyy").format(DateTime.parse(element.endtime))
        : "";
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                height: 20,
                width: 20,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SvgPicture.string(
                  cifsIcons[element.type] ?? "",
                ),
              ),
              Expanded(
                child: Text(
                  element.locationStreet,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(
            "$startTime - $endTime",
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (element.description != null)
                Text(
                  element.description,
                  style: TextStyle(
                    color: theme.textTheme.bodyText1.color,
                  ),
                ),
              if (element.url != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        launch(element.url);
                      },
                      child: const Text(
                        "More info",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        )
      ],
    );
  }
}
