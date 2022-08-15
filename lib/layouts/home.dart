import 'package:emergencyalert/layouts/drawer.dart';
import 'package:emergencyalert/layouts/profile.dart';
import 'package:emergencyalert/layouts/report.dart';
import 'package:emergencyalert/layouts/toaster.dart';
import 'package:emergencyalert/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../resources/screen_sizes.dart';

int lifeSaved = 547;
int caseReported = 5620;

PermissionStatus _isLocationPermissionGranted = PermissionStatus.denied;

List<String> dashboardItems = [
  "Report a Case",
  "Track Reported Case",
  "My Profile",
  "Help",
];

List<IconData> dashboardIcons = [
  Icons.report_problem,
  Icons.track_changes,
  Icons.person,
  Icons.help,
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Are you sure?"),
              content: const Text("Do you want to exit and logout?"),
              actions: <Widget>[
                TextButton(
                  child: const Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: const Text("Yes"),
                  onPressed: () => SystemNavigator.pop(),
                )
              ],
            )));
  }

  @override
  void initState() {
    super.initState();
    locationPermission();
  }

  locationPermission() async {
    _isLocationPermissionGranted = await Location.instance.hasPermission();
    if (_isLocationPermissionGranted == PermissionStatus.denied) {
      _isLocationPermissionGranted =
          await Location.instance.requestPermission();
    } else if (_isLocationPermissionGranted == PermissionStatus.deniedForever) {
      setState(() {
        showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                actions: [
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
                content: const Text(
                    "Please enable location permission in settings to use this app"),
                title: const Text("Location Permission Denied Permanetly"),
              );
            }));
      });
    } else if (_isLocationPermissionGranted == PermissionStatus.granted) {
      return;
    }
  }

  void oneSignal() {
    try {
      OneSignal.shared.setAppId("90c58bbe-a1b6-466e-b0e1-1b3b79563bea");

      OneSignal.shared
          .promptUserForPushNotificationPermission()
          .then((accepted) {});
    } catch (e) {
      // print(object)
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.5,
              title: const Text(
                'Emergency Alert',
              ),
            ),
            drawer: const Drawer(
              child: DrawerPage(),
            ),
            body: Center(
              child: Container(
                width: CreatedSystem(context: context).getIsScreeenWidthBig()
                    ? CreatedSystem(context: context).getPreciseWidth()
                    : CreatedSystem(context: context).getScreenWidth(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: Card(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(lifeSaved.toString(),
                                          style: TextStyle(
                                              fontFamily: "vt323",
                                              color: lightRed,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                      Text("Lives Saved",
                                          style: TextStyle(
                                              fontFamily: "adventPro",
                                              color: lightRed,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: Card(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(caseReported.toString(),
                                          style: TextStyle(
                                              fontFamily: "vt323",
                                              fontSize: 30,
                                              color: lightRed,
                                              fontWeight: FontWeight.bold)),
                                      Text("Cases Reported",
                                          style: TextStyle(
                                              fontFamily: "adventPro",
                                              color: lightRed,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: 4,
                          itemBuilder: (BuildContext context, int index) {
                            return MaterialButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                switch (index) {
                                  case 0:
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const ReportPage();
                                    }));
                                    break;
                                  case 1:
                                    AwesomeToaster.showToast(
                                        context: context,
                                        msg: "Not Yet Implemented");
                                    // Navigator.push(context, MaterialPageRoute(
                                    //     builder: (context) => TrackCasePage()));
                                    break;
                                  case 2:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfilePage()));
                                    break;
                                  case 3:
                                    AwesomeToaster.showToast(
                                        context: context,
                                        msg: "Not Yet Implemented");
                                    // Navigator.push(context, MaterialPageRoute(
                                    //     builder: (context) => HelpPage()));
                                    break;
                                }
                              },
                              child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  gradient: LinearGradient(
                                    colors: [startBlue, endBlue],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      dashboardIcons[index],
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    Text(
                                      dashboardItems[index],
                                      style: const TextStyle(
                                        fontFamily: "vt323",
                                        color: Colors.white,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
