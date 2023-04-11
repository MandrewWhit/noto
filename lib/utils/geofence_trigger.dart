import 'package:nowtowv1/models/location.dart';
import 'package:nowtowv1/utils/android_geofence_settings.dart';
import 'package:nowtowv1/utils/geofence_region.dart';

abstract class GeofenceTrigger {
  static final _androidSettings = AndroidGeofencingSettings(
      initialTrigger: [GeofenceEvent.exit],
      notificationResponsiveness: 0,
      loiteringDelay: 0);

  static bool _isInitialized = false;

  static final homeRegion = GeofenceRegion('home', 30.2721907406562,
      -95.5517534973172, 300.0, <GeofenceEvent>[GeofenceEvent.enter],
      androidSettings: _androidSettings);

  static Future<void> homeGeofenceCallback(
      List<String> id, Location location, GeofenceEvent event) async {
    // Check to see if this is the first time the callback is being called.
    if (!_isInitialized) {
      // Re-initialize state required to communicate with the garage door
      // server.
      await initialize();
      _isInitialized = true;
    }

    if (event == GeofenceEvent.enter) {
      print('enter event triggered');
    }
  }

  static Future<void> createHomeGeofence() async {
    await GeofencingManager.registerGeofence(
        GeofenceTrigger.homeRegion, GeofenceTrigger.homeGeofenceCallback);
  }
}
