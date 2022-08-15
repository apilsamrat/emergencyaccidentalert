// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:emergencyalert/layouts/toaster.dart';
import 'package:emergencyalert/logics/reportlogic.dart';
import 'package:emergencyalert/resources/datetime_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../resources/screen_sizes.dart';

File? _imageAndroid;
Uint8List? _imageWeb;

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

String? _selected;

TextEditingController _dateTimeTextEditingController = TextEditingController();
TextEditingController _locationTextEditingController = TextEditingController();
TextEditingController _accidentSeverityTextEditingController =
    TextEditingController();
TextEditingController _accidentTypeTextEditingController =
    TextEditingController();
TextEditingController _accidentCauseTextEditingController =
    TextEditingController();
TextEditingController _accidentDescriptionTextEditingController =
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
                  controller: _accidentDescriptionTextEditingController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
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
                const TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Please provide any other details",
                  ),
                ),
                const SizedBox(height: 10),
                const TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Your Phone Number",
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
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: ((context) {
                          void subNshow() async {
                            if (kIsWeb) {
                              var res = await ReportAccident(context: context)
                                  .submit(
                                      accidentSeverity: _selected.toString(),
                                      accidentType:
                                          _accidentTypeTextEditingController
                                              .text,
                                      accidentLocation:
                                          _locationTextEditingController.text,
                                      accidentDescription:
                                          _accidentDescriptionTextEditingController
                                              .text,
                                      accidentDateandTime:
                                          _dateTimeTextEditingController.text,
                                      accidentCause:
                                          _accidentCauseTextEditingController
                                              .text,
                                      imageDataWeb: _imageWeb);
                              AwesomeToaster.showToast(
                                  context: context, msg: res);
                              Navigator.pop(context);
                            } else {
                              var res = await ReportAccident(context: context)
                                  .submit(
                                      accidentSeverity:
                                          _accidentSeverityTextEditingController
                                              .text,
                                      accidentType:
                                          _accidentTypeTextEditingController
                                              .text,
                                      accidentLocation:
                                          _locationTextEditingController.text,
                                      accidentDescription:
                                          _accidentDescriptionTextEditingController
                                              .text,
                                      accidentDateandTime:
                                          _dateTimeTextEditingController.text,
                                      accidentCause:
                                          _accidentCauseTextEditingController
                                              .text,
                                      imageFileAndroid: _imageAndroid);
                              AwesomeToaster.showToast(
                                  context: context, msg: res);
                              Navigator.pop(context);
                            }
                          }

                          subNshow();
                          return const AlertDialog(
                            title: Text("Please wait...."),
                            content: CupertinoActivityIndicator(),
                          );
                        }));
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
