import 'package:emergencyalert/resources/datetime_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

String? _selected;

TextEditingController _dateTimeTextEditingController = TextEditingController();
TextEditingController _locationTextEditingController = TextEditingController();

class _ReportPageState extends State<ReportPage> {
  void getLocation() async {
    await Location.instance.getLocation().then((value) {
      _locationTextEditingController.text =
          "https://www.google.com/maps/search/?api=1&query=${value.latitude},${value.longitude}";
      Navigator.pop(context);
    });
  }

  locationService() async {
    await showDialog(
        // barrierDismissible: false,
        context: context,
        builder: ((context) {
          getLocation();
          return AlertDialog(
            title: const Text("Getting Location"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Please wait while we get your location"),
                ),
                CupertinoActivityIndicator(
                  radius: 12,
                  color: Colors.blue,
                ),
              ],
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reporting Accident"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              const Text("Report Accident"),
              const Text("Please fill in the form"),
              const SizedBox(height: 20),
              DropdownButton(
                isExpanded: true,
                enableFeedback: true,
                hint: const Text("Select Severity of Accident"),
                value: _selected,
                items: const [
                  DropdownMenuItem(
                    value: "null",
                    child: Text(
                      "Accident Severity",
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Low",
                    child: Text(
                      "Low",
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Medium",
                    child: Text(
                      "Medium",
                    ),
                  ),
                  DropdownMenuItem(
                    value: "High",
                    child: Text(
                      "High",
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selected = value.toString();
                  });
                  FocusScope.of(context).unfocus();
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: _locationTextEditingController,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        locationService();
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Accident Location",
                      ),
                    ),
                  ),
                  TextButton(
                    child: const Text("Get Location"),
                    onPressed: () {
                      locationService();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      controller: _dateTimeTextEditingController,
                      readOnly: true,
                      onTap: () {
                        DateTimePicker.selectDateTime(context)
                            .then((value) => setState(() {
                                  _dateTimeTextEditingController.text =
                                      value.toString();
                                  FocusScope.of(context).unfocus();
                                }));
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Accident Date and Time",
                      ),
                    ),
                  ),
                  TextButton(
                    child: const Text("Input Date and Time"),
                    onPressed: () {
                      DateTimePicker.selectDateTime(context)
                          .then((value) => setState(() {
                                _dateTimeTextEditingController.text =
                                    value.toString();
                                FocusScope.of(context).unfocus();
                              }));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:
                      "Accident Type eg. Car Accident, Bus Accident, etc.",
                ),
              ),
              const SizedBox(height: 10),
              const TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Accident Description",
                ),
              ),
              const SizedBox(height: 10),
              const TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Accident Cause",
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  launchUrlString(_locationTextEditingController.text,
                      webViewConfiguration: const WebViewConfiguration(
                        headers: {
                          "User-Agent":
                              "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.34 (KHTML, like Gecko) Version/11.0 Mobile/15A5341f Safari/604.1",
                        },
                      ),
                      mode: LaunchMode.inAppWebView);
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(125, 40)),
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                child: const Text(
                  "Submit Report",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
