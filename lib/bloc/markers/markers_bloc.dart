import 'dart:developer' as dev;
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:latlong2/latlong.dart';
import 'package:nowtowv1/bloc/markers/markers_events.dart';
import 'package:nowtowv1/bloc/markers/markers_state.dart';
import 'package:nowtowv1/data_structures/custom_stack.dart';
import 'package:nowtowv1/models/marker.dart';
import 'package:nowtowv1/utils/firebase.dart';
import 'package:nowtowv1/utils/firebase_storage.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:nowtowv1/utils/location_service.dart';

class MarkersBloc extends Bloc<MarkersEvent, MarkersState> {
  MarkersBloc({required this.service, required this.storage})
      : super(MarkersState()) {
    on<CreateMarkerEvent>(_mapCreateEventToState);
    on<GetMarkersEvent>(_mapGetEventToState);
    on<UpdateMarkerEvent>(_mapUpdateEventToState);
    on<DeleteMarkersEvent>(_mapDeleteEventToState);
    on<AddGeofenceEvent>(_mapAddGeofenceEventToState);
  }
  final FirebaseService service;
  final Storage storage;

  void _mapCreateEventToState(
      CreateMarkerEvent event, Emitter<MarkersState> emit) async {
    emit(state.copyWith(status: MarkersStatus.loading));
    try {
      CustomMarker newMarker = event.marker;
      newMarker.uid = event.user!.uid;
      String newId = await service.createNewMarkerFirebase(newMarker);
      newMarker.id = newId;

      //add picture to firebase
      if (event.marker.imagePaths != null) {
        if (event.marker.imagePaths!.isNotEmpty) {
          storage.uploadFile(
              event.marker.imagePaths![0], "$newId", "MarkerPics");
          newMarker.imagePaths = [newId];
          service.updateMarker(newId, newMarker);
        }
      }

      List<CustomMarker> newMarkers = state.markers ?? [];
      newMarkers.add(newMarker);

      emit(
        state.copyWith(status: MarkersStatus.success, markers: newMarkers),
      );
    } catch (error, stacktrace) {
      dev.log(stacktrace.toString());
      emit(state.copyWith(status: MarkersStatus.error));
    }
  }

  void _mapGetEventToState(
      GetMarkersEvent event, Emitter<MarkersState> emit) async {
    emit(state.copyWith(status: MarkersStatus.loading));
    try {
      List<CustomMarker> newMarkers =
          await service.getMarkersFromFirebase(event.location) ?? [];

      emit(
        state.copyWith(status: MarkersStatus.success, markers: newMarkers),
      );
    } catch (error, stacktrace) {
      dev.log(stacktrace.toString());
      emit(state.copyWith(status: MarkersStatus.error));
    }
  }

  void _mapUpdateEventToState(
      UpdateMarkerEvent event, Emitter<MarkersState> emit) async {
    emit(state.copyWith(status: MarkersStatus.loading));
    try {
      List<CustomMarker> newMarkers = state.markers ?? [];
      for (int i = 0; i < newMarkers.length; i++) {
        if (event.id == newMarkers[i].id) {
          newMarkers[i] = event.marker;
          service.updateMarker(event.id, event.marker);
          break;
        }
      }
      emit(
        state.copyWith(status: MarkersStatus.success, markers: newMarkers),
      );
    } catch (error, stacktrace) {
      dev.log(stacktrace.toString());
      emit(state.copyWith(status: MarkersStatus.error));
    }
  }

  void _mapDeleteEventToState(
      DeleteMarkersEvent event, Emitter<MarkersState> emit) async {
    emit(state.copyWith(status: MarkersStatus.loading));
    try {
      List<CustomMarker> oldMarkers = state.markers ?? [];
      List<CustomMarker> newMarkers = state.markers ?? [];
      for (int i = 0; i < oldMarkers.length; i++) {
        for (int j = 0; j < event.ids.length; j++) {
          if (oldMarkers[i].id == event.ids[j]) {
            newMarkers.remove(oldMarkers[i]);
            service.deleteMarker(event.ids[j]);
            _deleteGeofence(event.ids[j]);
            break;
          }
        }
      }
      emit(
        state.copyWith(status: MarkersStatus.success, markers: newMarkers),
      );
    } catch (error, stacktrace) {
      dev.log(stacktrace.toString());
      emit(state.copyWith(status: MarkersStatus.error));
    }
  }

  void _mapAddGeofenceEventToState(
      AddGeofenceEvent event, Emitter<MarkersState> emit) async {
    emit(state.copyWith(status: MarkersStatus.loading));
    try {
      List<CustomMarker> newMarkers =
          await service.getMarkersFromFirebase(event.location) ?? [];
      for (int i = 0; i < newMarkers.length; i++) {
        _addGeofence(
            newMarkers[i].lat, newMarkers[i].lng, newMarkers[i].id ?? "");
      }

      // set background geolocation events
      bg.BackgroundGeolocation.onGeofence(_onGeofence);

      // Configure the plugin and call ready
      bg.BackgroundGeolocation.ready(bg.Config(
              desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
              distanceFilter: 10.0,
              stopOnTerminate: false,
              startOnBoot: true,
              debug: false, // true
              logLevel: bg.Config.LOG_LEVEL_OFF // bg.Config.LOG_LEVEL_VERBOSE
              ))
          .then((bg.State state) {
        if (!state.enabled) {
          // start the plugin
          bg.BackgroundGeolocation.start();

          // start geofences only
          bg.BackgroundGeolocation.startGeofences();
        }
      });

      List<CustomMarker> nearbyMarkers = getNearbyMarkers(newMarkers);
      List<Image> nearbyImages = await getNearbyImages(nearbyMarkers);
      emit(
        state.copyWith(
            status: MarkersStatus.success,
            markers: newMarkers,
            nearbyMarkers: nearbyMarkers,
            nearbyImages: nearbyImages),
      );
    } catch (error, stacktrace) {
      dev.log(stacktrace.toString());
      emit(state.copyWith(status: MarkersStatus.error));
    }
  }

  void _addGeofence(double lat, double lng, String id) {
    bg.BackgroundGeolocation.addGeofence(bg.Geofence(
      identifier: id,
      radius: 150,
      latitude: lat,
      longitude: lng,
      notifyOnEntry: true,
      notifyOnExit: false,
      notifyOnDwell: false,
      loiteringDelay: 30000, // 30 seconds
    )).then((bool success) {
      dev.log('[addGeofence] success with $lat and $lng');
    }).catchError((error) {
      dev.log('[addGeofence] FAILURE: $error');
    });
  }

  void _deleteGeofence(String id) {
    bg.BackgroundGeolocation.destroyLocation(id);
  }

  void _onGeofence(bg.GeofenceEvent event) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    var platformChannelSpecifics = const NotificationDetails(
        iOS: IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ));
    await flutterLocalNotificationsPlugin
        .show(0, 'Tow Trap Nearby!', 'Open the Noto app for details',
            platformChannelSpecifics)
        .then((result) {})
        .catchError((onError) {
      print('[flutterLocalNotificationsPlugin.show] ERROR: $onError');
    });
  }

  List<CustomMarker> getNearbyMarkers(List<CustomMarker> allMarkers) {
    MyStack<CustomMarker> nearbyMarkers = MyStack<CustomMarker>();
    MyStack<double> nearbyMarkersDist = MyStack<double>();
    if (LocationService.currentLocation != null) {
      if (allMarkers != null) {
        LatLng? userLoc = LocationService.currentLocation;
        for (int i = 0; i < allMarkers!.length; i++) {
          bool notAlreadyAdded = true;
          var newDistance = sqrt(
              pow((userLoc!.latitude - allMarkers![i].lat), 2) +
                  pow((userLoc.longitude - allMarkers![i].lng), 2));
          for (int j = 0; j < nearbyMarkers.getSize; j++) {
            if (newDistance < nearbyMarkersDist.getAt(j)) {
              nearbyMarkers.insertAt(j, allMarkers![i]);
              nearbyMarkersDist.insertAt(j, newDistance);
              notAlreadyAdded = false;
              break;
            }
          }
          if (nearbyMarkers.getSize < 5 && notAlreadyAdded) {
            nearbyMarkers.pushEnd(allMarkers![i]);
            nearbyMarkersDist.pushEnd(newDistance);
          }
        }
      }
    }
    return nearbyMarkers.toList;
  }

  Future<List<Image>> getNearbyImages(List<CustomMarker> nearbyMarkers) async {
    List<Image> nearbyImages = [];
    for (int i = 0; i < nearbyMarkers.length; i++) {
      if (nearbyMarkers[i].imagePaths != null) {
        if (nearbyMarkers[i].imagePaths!.isNotEmpty) {
          var url =
              await storage.getImage(nearbyMarkers[i].imagePaths![0]) ?? "";
          nearbyImages.add(Image.network(
            url,
            width: 500,
            height: 500,
          ));
        } else {
          nearbyImages.add(Image.asset('assets/clip-car.png'));
        }
      } else {
        nearbyImages.add(Image.asset('assets/clip-car.png'));
      }
    }
    return nearbyImages;
  }
}
