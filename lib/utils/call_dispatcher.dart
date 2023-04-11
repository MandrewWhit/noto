// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:nowtowv1/models/location.dart';
// import 'package:nowtowv1/utils/geofence_region.dart';

// void callbackDispatcher() {
//   const MethodChannel _backgroundChannel =
//       MethodChannel('plugins.flutter.io/geofencing_plugin_background');
//   WidgetsFlutterBinding.ensureInitialized();

//   _backgroundChannel.setMethodCallHandler((MethodCall call) async {
//     final List<dynamic> args = call.arguments;
//     final Function? callback = PluginUtilities.getCallbackFromHandle(
//         CallbackHandle.fromRawHandle(args[0]));
//     assert(callback != null);
//     final List<String> triggeringGeofences = args[1].cast<String>();
//     final List<double> locationList = <double>[];
//     // 0.0 becomes 0 somewhere during the method call, resulting in wrong
//     // runtime type (int instead of double). This is a simple way to get
//     // around casting in another complicated manner.
//     args[2]
//         .forEach((dynamic e) => locationList.add(double.parse(e.toString())));
//     final Location triggeringLocation = locationFromList(locationList);
//     final GeofenceEvent event = intToGeofenceEvent(args[3]);
//     callback!(triggeringGeofences, triggeringLocation, event);
//   });
//   _backgroundChannel.invokeMethod('GeofencingService.initialized');
// }
