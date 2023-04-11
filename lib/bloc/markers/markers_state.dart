// Dart imports:

// Flutter imports:

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nowtowv1/models/marker.dart';

// Project imports:

enum MarkersStatus { initial, success, error, loading }

extension MarkersStatusX on MarkersStatus {
  bool get isInitial => this == MarkersStatus.initial;
  bool get isSuccess => this == MarkersStatus.success;
  bool get isError => this == MarkersStatus.error;
  bool get isLoading => this == MarkersStatus.loading;
}

class MarkersState extends Equatable {
  MarkersState({this.status = MarkersStatus.initial, this.markers});

  final List<CustomMarker>? markers;
  final MarkersStatus status;

  @override
  List<Object?> get props => [markers, status];

  MarkersState copyWith({MarkersStatus? status, List<CustomMarker>? markers}) {
    return MarkersState(
        status: status ?? this.status, markers: markers ?? this.markers);
  }
}
