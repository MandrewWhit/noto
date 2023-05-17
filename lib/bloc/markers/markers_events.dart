import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:nowtowv1/models/marker.dart';

@immutable
abstract class MarkersEvent {
  const MarkersEvent();

  List<Object> get props => [];
}

class CreateMarkerEvent extends MarkersEvent {
  CreateMarkerEvent({this.user, required this.marker});

  final User? user;
  final CustomMarker marker;

  @override
  List<Object> get props => [user ?? "No User", marker];

  @override
  String toString() => 'Create Marker Event';
}

class AddGeofenceEvent extends MarkersEvent {
  const AddGeofenceEvent({required this.location});

  final LatLng location;

  @override
  List<Object> get props => [location];

  @override
  String toString() => 'Add Geofence Event';
}

class GetMarkersEvent extends MarkersEvent {
  GetMarkersEvent({required this.location});

  final LatLng location;

  @override
  List<Object> get props => [location];

  @override
  String toString() => 'Get Markers Event';
}

class DeleteMarkersEvent extends MarkersEvent {
  DeleteMarkersEvent({required this.ids});

  final List<String> ids;

  @override
  List<Object> get props => [ids];

  @override
  String toString() => 'Get Markers Event';
}

class UpdateMarkerEvent extends MarkersEvent {
  UpdateMarkerEvent({required this.marker, required this.id});

  final CustomMarker marker;
  final String id;

  @override
  List<Object> get props => [marker, id];

  @override
  String toString() => 'Get Markers Event';
}

class GetNearbyMarkersEvent extends MarkersEvent {
  GetNearbyMarkersEvent({required this.location});

  final LatLng location;

  @override
  List<Object> get props => [location];

  @override
  String toString() => 'Get Nearby Markers Event';
}
