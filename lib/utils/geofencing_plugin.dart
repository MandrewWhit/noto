import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nowtowv1/models/location.dart';
import 'package:nowtowv1/utils/geofence_region.dart';

abstract class GeofencingPlugin {
  static const MethodChannel _channel =
      const MethodChannel('plugins.flutter.io/geofencing_plugin');

  static Future<bool> initialize() async {
    final callback = PluginUtilities.getCallbackHandle(callbackDispatcher);
    return await _channel.invokeMethod('GeofencingPlugin.initializeService',
        <dynamic>[callback?.toRawHandle()]);
  }

  static Future<bool> registerGeofence(
      GeofenceRegion region,
      void Function(List<String> id, Location location, GeofenceEvent event)
          callback) async {
    if (Platform.isIOS &&
        region.triggers.contains(GeofenceEvent.dwell) &&
        (region.triggers.length == 1)) {
      throw UnsupportedError("iOS does not support 'GeofenceEvent.dwell'");
    }
    final args = <dynamic>[
      PluginUtilities.getCallbackHandle(callback)?.toRawHandle()
    ];
    args.addAll(region.toArgs());
    await _channel.invokeMethod('GeofencingPlugin.registerGeofence', args);
    return true;
  }

  /*
  * … `removeGeofence` methods here …
  */
}

void callbackDispatcher() {
  // 1. Initialize MethodChannel used to communicate with the platform portion of the plugin.
  const MethodChannel _backgroundChannel =
      MethodChannel('plugins.flutter.io/geofencing_plugin_background');

  // 2. Setup internal state needed for MethodChannels.
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Listen for background events from the platform portion of the plugin.
  _backgroundChannel.setMethodCallHandler((MethodCall call) async {
    final args = call.arguments;

    // 3.1. Retrieve callback instance for handle.
    final Function? callback = PluginUtilities.getCallbackFromHandle(
        CallbackHandle.fromRawHandle(args[0]));
    assert(callback != null);

    // 3.2. Preprocess arguments.
    final triggeringGeofences = args[1].cast<String>();
    final locationList = args[2].cast<double>();
    final triggeringLocation = locationFromList(locationList);
    final GeofenceEvent event = intToGeofenceEvent(args[3]);

    // 3.3. Invoke callback.
    callback!(triggeringGeofences, triggeringLocation, event);
  });

  // 4. Alert plugin that the callback handler is ready for events.
  _backgroundChannel.invokeMethod('GeofencingService.initialized');
}
