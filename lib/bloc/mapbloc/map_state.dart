// Dart imports:

// Flutter imports:

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nowtowv1/models/marker.dart';

// Project imports:

enum MapStatus { initial, success, error, loading }

extension MapStatusX on MapStatus {
  bool get isInitial => this == MapStatus.initial;
  bool get isSuccess => this == MapStatus.success;
  bool get isError => this == MapStatus.error;
  bool get isLoading => this == MapStatus.loading;
}

class MapState extends Equatable {
  MapState(
      {this.status = MapStatus.initial,
      this.showMarkerDesc = false,
      this.mapController,
      this.locationLoaded = false});

  final MapController? mapController;
  final bool showMarkerDesc;
  final MapStatus status;
  final bool locationLoaded;

  @override
  List<Object?> get props => [status];

  MapState copyWith(
      {MapStatus? status,
      MapController? mapController,
      bool? showMarkerDesc,
      bool? locationLoaded}) {
    return MapState(
        status: status ?? this.status,
        mapController: mapController ?? this.mapController,
        showMarkerDesc: showMarkerDesc ?? this.showMarkerDesc,
        locationLoaded: locationLoaded ?? this.locationLoaded);
  }
}
