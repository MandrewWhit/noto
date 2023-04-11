import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nowtowv1/models/marker.dart';

@immutable
abstract class MapEvent {
  const MapEvent();

  List<Object> get props => [];
}

class ToggleEvent extends MapEvent {
  ToggleEvent();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Toggle Event';
}

class SetMapControllerEvent extends MapEvent {
  SetMapControllerEvent({required this.mapController});

  final MapController mapController;

  @override
  List<Object> get props => [mapController];

  @override
  String toString() => 'Set Map Controller Event';
}

class RecenterEvent extends MapEvent {
  RecenterEvent();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Recenter Event';
}

class SetLocationEvent extends MapEvent {
  SetLocationEvent({required this.locationLoaded});

  bool locationLoaded;

  @override
  List<Object> get props => [locationLoaded];

  @override
  String toString() => 'Set Location Event';
}
