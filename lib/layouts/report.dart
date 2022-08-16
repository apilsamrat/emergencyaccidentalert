// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:emergencyalert/layouts/toaster.dart';
import 'package:emergencyalert/logics/reportlogic.dart';
import 'package:emergencyalert/resources/colors.dart';
import 'package:emergencyalert/resources/datetime_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../resources/screen_sizes.dart';

File? _imageAndroid;
Uint8List? _imageWeb;

bool _isSubmitEnabled = true;

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

String? _selectedAccidentSeverity;

TextEditingController _dateTimeTextEditingController = TextEditingController();
TextEditingController _locationTextEditingController = TextEditingController();
TextEditingController _accidentTypeTextEditingController =
    TextEditingController();
TextEditingController _accidentCauseTextEditingController =
    TextEditingController();
TextEditingController _noOfPeopleInvolvedTextEditingController =
    TextEditingController();

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
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: CreatedSystem(context: context).getIsScreeenWidthBig()
                ? CreatedSystem(context: context).getPreciseWidth()
                : CreatedSystem(context: context).getScreenWidth(),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              children: [
                const Text("Report Accident"),
                const SizedBox(height: 10),
                Wrap(
                  children: const [
                    Text(
                        "Please fill the form with accurate information. Misleading information will be considered as a crime and will be reported to the authorities.",
                        style: TextStyle(fontSize: 12, color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 30),
                DropdownButton(
                  isExpanded: true,
                  enableFeedback: true,
                  hint: const Text("Select Severity of Accident"),
                  value: _selectedAccidentSeverity,
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
                      _selectedAccidentSeverity = value.toString();
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
                TextField(
                  controller: _accidentTypeTextEditingController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Emergency Type  eg. Road Accident, Fire, etc.",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _accidentCauseTextEditingController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Accident Cause",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _noOfPeopleInvolvedTextEditingController,
                  maxLines: null,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "No of People Involved",
                  ),
                ),
                const SizedBox(height: 10),
                kIsWeb
                    ? _imageWeb == null
                        ? const SizedBox(height: 10)
                        : Image.memory(_imageWeb!, height: 200)
                    : _imageAndroid == null
                        ? const SizedBox(height: 10)
                        : Image.file(_imageAndroid!, height: 200),
                TextButton.icon(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.image,
                        dialogTitle: "Select Scenario Image",
                      );
                      if (result != null) {
                        setState(() {
                          if (kIsWeb) {
                            _imageWeb = result.files.first.bytes;
                          } else {
                            _imageAndroid =
                                File(result.files.first.path.toString());
                          }
                        });
                      }
                    },
                    icon: const Icon(Icons.person),
                    label: const Text("Please provide an Image")),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () async {
                    if (_isSubmitEnabled) {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: ((context) {
                            void subNshow() async {
                              if (kIsWeb) {
                                var res = await ReportAccident(
                                        context: context)
                                    .submit(
                                        accidentLocation:
                                            _locationTextEditingController.text,
                                        accidentDateandTime:
                                            _dateTimeTextEditingController.text,
                                        accidentSeverity:
                                            _selectedAccidentSeverity!,
                                        accidentType:
                                            _accidentTypeTextEditingController
                                                .text,
                                        noOfInjured:
                                            _noOfPeopleInvolvedTextEditingController
                                                .text,
                                        accidentCause:
                                            _accidentCauseTextEditingController
                                                .text,
                                        imageDataWeb: _imageWeb);
                                AwesomeToaster.showToast(
                                    context: context, msg: res);
                                Navigator.pop(context);
                                if (res == "Success") {
                                  _isSubmitEnabled = false;
                                  if (res == "Success") {
                                    _isSubmitEnabled = false;
                                  }
                                }
                              } else {
                                var res = await ReportAccident(
                                        context: context)
                                    .submit(
                                        accidentLocation:
                                            _locationTextEditingController.text,
                                        accidentDateandTime:
                                            _dateTimeTextEditingController.text,
                                        accidentSeverity:
                                            _selectedAccidentSeverity!,
                                        accidentType:
                                            _accidentTypeTextEditingController
                                                .text,
                                        noOfInjured:
                                            _noOfPeopleInvolvedTextEditingController
                                                .text,
                                        accidentCause:
                                            _accidentCauseTextEditingController
                                                .text,
                                        imageFileAndroid: _imageAndroid);
                                AwesomeToaster.showToast(
                                    context: context, msg: res);
                                Navigator.pop(context);

                                if (res == "Success") {
                                  _isSubmitEnabled = false;
                                }
                              }
                            }

                            if (_locationTextEditingController.text.isEmpty ||
                                _dateTimeTextEditingController.text.isEmpty ||
                                _accidentTypeTextEditingController
                                    .text.isEmpty ||
                                _noOfPeopleInvolvedTextEditingController
                                    .text.isEmpty ||
                                _accidentCauseTextEditingController
                                    .text.isEmpty ||
                                _selectedAccidentSeverity == null ||
                                (_imageAndroid == null && _imageWeb == null)) {
                              return AlertDialog(
                                title: Text("Error",
                                    style: TextStyle(
                                        fontFamily: "vt323", color: red)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text("Please fill all fields"),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("OKAY"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            } else {
                              subNshow();
                              return const AlertDialog(
                                title: Text("Please wait...."),
                                content: CupertinoActivityIndicator(),
                              );
                            }
                          }));
                    } else {
                      AwesomeToaster.showLongToast(
                          context: context,
                          duration: const Duration(seconds: 5),
                          msg: "You have already submitted an accident report");
                    }
                  },
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(125, 40)),
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
      ),
    );
  }
}
