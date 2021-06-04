import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trufi_core/entities/plan_entity/plan_entity.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

enum CustomDaySelect {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

extension CustomDaySelectExtension on CustomDaySelect {
  static final translateEn = <CustomDaySelect, String>{
    CustomDaySelect.monday: "Monday",
    CustomDaySelect.tuesday: "Tuesday",
    CustomDaySelect.wednesday: "wednesday",
    CustomDaySelect.thursday: "Thursday",
    CustomDaySelect.friday: "Friday",
    CustomDaySelect.saturday: "Saturday",
    CustomDaySelect.sunday: "Sunday",
  };

  static final translateDE = <CustomDaySelect, String>{
    CustomDaySelect.monday: "Montag",
    CustomDaySelect.tuesday: "Dienstag",
    CustomDaySelect.wednesday: "Mittwoch",
    CustomDaySelect.thursday: "Donnerstag",
    CustomDaySelect.friday: "Freitag",
    CustomDaySelect.saturday: "Samstag",
    CustomDaySelect.sunday: "Sonntag",
  };
  String getTranslate(String languageCode) =>
      languageCode == 'en' ? translateEn[this] : translateDE[this];
}

class OfferCarpoolScreen extends StatefulWidget {
  final PlanItineraryLeg planItineraryLeg;

  const OfferCarpoolScreen({Key key, this.planItineraryLeg}) : super(key: key);

  @override
  _OfferCarpoolScreenState createState() => _OfferCarpoolScreenState();
}

class _OfferCarpoolScreenState extends State<OfferCarpoolScreen> {
  TextEditingController phoneController = TextEditingController();
  int offerType = 0;
  bool termsChecked = false;

  bool loading = false;
  String fetchError;

  bool done = false;
  Set<CustomDaySelect> daysSelected = {};
  @override
  Widget build(BuildContext context) {
    final localeName = TrufiLocalization.of(context).localeName;
    final theme = Theme.of(context);
    final daysSelectedFormated = daysSelected
        .toList()
        .map(
          (element) => element.getTranslate(localeName),
        )
        .join(", ");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localeName == "en" ? "Offer carpool" : "Fahrgemeinschaft anbieten",
        ),
      ),
      body: ListView(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: done
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          localeName == "en" ? "Thank you!" : "Vielen Dank!",
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          localeName == "en"
                              ? "Your offer from ${widget.planItineraryLeg.fromName} to ${widget.planItineraryLeg.toName} was added."
                              : "Ihr Inserat von ${widget.planItineraryLeg.fromName} nach ${widget.planItineraryLeg.toName} wurde eingestellt.",
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.black,
                              ),
                        ),
                        const SizedBox(height: 20),
                        if (offerType == 0)
                          Text(
                            localeName == "en"
                                ? "You've set the following time: ${DateFormat('dd/MM/yyyy').format(widget.planItineraryLeg.startTime)} at ${DateFormat('hh:mm aa').format(widget.planItineraryLeg.startTime)}."
                                : "Sie haben für den folgendes Datum und Uhrzeit inseriert: ${DateFormat('dd/MM/yyyy').format(widget.planItineraryLeg.startTime)} um ${DateFormat('hh:mm aa').format(widget.planItineraryLeg.startTime)}.",
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: Colors.black,
                                    ),
                          )
                        else
                          Text(
                            localeName == "en"
                                ? "You've set the following times and days: $daysSelectedFormated at ${DateFormat('hh:mm aa').format(widget.planItineraryLeg.startTime)}."
                                : "Sie haben für folgende Zeit und Tage inseriert: $daysSelectedFormated um ${DateFormat('hh:mm aa').format(widget.planItineraryLeg.startTime)}.",
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: Colors.black,
                                    ),
                          ),
                        const SizedBox(height: 20),
                        Text(
                          localeName == "en"
                              ? "Your offer will be deleted after the day of the ride. Regular ones will be removed after three months."
                              : "Ihr Inserat wird nach Ablauf der Zeit jedoch spätestens nach drei Monaten (bei regelmäßigen Fahrten) gelöscht.",
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.black,
                              ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: theme.primaryColor),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            localeName == "en" ? "Close" : "Schließen",
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          localeName == "en" ? "Your trip" : "Ihr Inserat",
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              localeName == "en" ? "Origin: " : "Start: ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              "${widget.planItineraryLeg.fromName} ${localeName == "en" ? " at " : " um "} ${DateFormat('hh:mm aa').format(widget.planItineraryLeg.startTime)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              localeName == "en"
                                  ? "Destination: "
                                  : "Zielort: ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              widget.planItineraryLeg.toName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          localeName == "en"
                              ? "How often do you want to add the offer?"
                              : "Wie oft bieten Sie diese Fahrt an?",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 0,
                              groupValue: offerType,
                              onChanged: _handleRadioValueChange,
                            ),
                            Text(
                              localeName == "en" ? "Once" : "Einmalig",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                            Radio(
                              value: 1,
                              groupValue: offerType,
                              onChanged: _handleRadioValueChange,
                            ),
                            Text(
                              localeName == "en" ? "Recurring" : "Regelmäßig",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                          ],
                        ),
                        if (offerType == 1)
                          Card(
                            child: Column(
                              children: CustomDaySelect.values
                                  .map((element) => Row(
                                        children: [
                                          Checkbox(
                                              value: daysSelected
                                                  .contains(element),
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value) {
                                                    daysSelected.add(element);
                                                  } else {
                                                    daysSelected
                                                        .remove(element);
                                                  }
                                                });
                                              }),
                                          Text(
                                            element.getTranslate(
                                              localeName,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  color: Colors.black,
                                                ),
                                          ),
                                        ],
                                      ))
                                  .toList(),
                            ),
                          ),
                        TextField(
                          controller: phoneController,
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: localeName == "en"
                                ? "Add your phone number"
                                : "Bitte fügen Sie Ihre Telefonnummer hinzu:",
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          localeName == "en"
                              ? "This will be shown to people interested in the ride."
                              : "Diese wird Interessenten angezeigt.",
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.black,
                              ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                                value: termsChecked,
                                onChanged: (value) {
                                  setState(() {
                                    termsChecked = value;
                                  });
                                }),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      style: theme.textTheme.caption.copyWith(
                                        color: Colors.black,
                                      ),
                                      text: localeName == "en"
                                          ? "I have read and agreed to the "
                                          : "Ich habe die ",
                                    ),
                                    TextSpan(
                                      style: theme.textTheme.caption.copyWith(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                      ),
                                      text: localeName == 'en'
                                          ? "privacy policy"
                                          : "Datenschutzbestimmungen",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launch(
                                              "https://www.fahrgemeinschaft.de/datenschutz.php");
                                        },
                                    ),
                                    TextSpan(
                                      style: theme.textTheme.caption.copyWith(
                                        color: Colors.black,
                                      ),
                                      text: localeName == "en"
                                          ? " and "
                                          : " und die ",
                                    ),
                                    TextSpan(
                                      style: theme.textTheme.caption.copyWith(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                      ),
                                      text: localeName == 'en'
                                          ? "terms of use."
                                          : "AGB",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launch(
                                              "https://www.fahrgemeinschaft.de/rules.php");
                                        },
                                    ),
                                    TextSpan(
                                      style: theme.textTheme.caption.copyWith(
                                        color: Colors.black,
                                      ),
                                      text: localeName == "en"
                                          ? ""
                                          : " gelesen und erkläre mich einverstanden.",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: theme.primaryColor),
                          onPressed: termsChecked && !loading
                              ? createOfferCarpool
                              : null,
                          child: !loading
                              ? Text(
                                  localeName == "en"
                                      ? "Offer carpool"
                                      : "Fahrgemeinschaft anbieten",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                )
                              : const LinearProgressIndicator(),
                        ),
                        if (fetchError != null) ...[
                          const SizedBox(height: 30),
                          Text(
                            fetchError,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      offerType = value;
    });
  }

  Future<void> createOfferCarpool() async {
    if (!mounted) return;
    setState(() {
      fetchError = null;
      loading = true;
    });
    await _createOfferCarpool().then((value) {
      if (mounted) {
        setState(() {
          done = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          fetchError = "$error";
          loading = false;
        });
      }
    });
  }

  Future<void> _createOfferCarpool() async {
    final Map body = {
      "origin": {
        "label": "71083 Herrenberg",
        "lat": 48.61747733567233,
        "lon": 8.841934204101564
      },
      "destination": {
        "label": "Hauptstraße, 71154 Nufringen",
        "lat": 48.62343481126179,
        "lon": 8.893647193908693
      },
      "phoneNumber": phoneController.text ?? "",
      "time": offerType == 0
          ? {"type": "one-off", "departureTime": "04:53", "date": "2021-06-04"}
          : {
              "type": "recurring",
              "departureTime": "04:53",
              "weekdays": {
                "monday": daysSelected.contains(CustomDaySelect.monday),
                "tuesday": daysSelected.contains(CustomDaySelect.tuesday),
                "wednesday": daysSelected.contains(CustomDaySelect.wednesday),
                "thursday": daysSelected.contains(CustomDaySelect.thursday),
                "friday": daysSelected.contains(CustomDaySelect.friday),
                "saturday": daysSelected.contains(CustomDaySelect.saturday),
                "sunday": daysSelected.contains(CustomDaySelect.sunday)
              }
            }
    };
    final response = await http.post(
      Uri.parse(
        "https://dev.stadtnavi.eu/carpool-offers",
      ),
      body: jsonEncode(body),
      headers: {'content-type': 'application/json'},
    );
    if (response.statusCode != 200) throw response.body;
  }
}
