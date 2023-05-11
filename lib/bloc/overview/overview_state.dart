// Dart imports:

// Flutter imports:

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nowtowv1/models/marker.dart';

// Project imports:

enum OverviewStatus { initial, success, error, loading }

extension OverviewStatusX on OverviewStatus {
  bool get isInitial => this == OverviewStatus.initial;
  bool get isSuccess => this == OverviewStatus.success;
  bool get isError => this == OverviewStatus.error;
  bool get isLoading => this == OverviewStatus.loading;
}

class OverviewState extends Equatable {
  OverviewState(
      {this.status = OverviewStatus.initial,
      this.opacity,
      this.marker,
      this.panelHeightClosed,
      this.panelHeightOpened,
      this.image,
      this.explore,
      this.isDraggable,
      this.hasImage});

  final CustomMarker? marker;
  final OverviewStatus status;
  final bool? opacity;
  final double? panelHeightClosed;
  final double? panelHeightOpened;
  final Image? image;
  final bool? explore;
  final bool? isDraggable;
  final bool? hasImage;

  @override
  List<Object?> get props => [
        marker,
        opacity,
        status,
        panelHeightClosed,
        panelHeightOpened,
        image,
        explore,
        isDraggable,
        hasImage,
      ];

  OverviewState copyWith(
      {OverviewStatus? status,
      CustomMarker? marker,
      bool? opacity,
      double? panelHeightClosed,
      double? panelHeightOpened,
      Image? image,
      bool? explore,
      bool? isDraggable,
      bool? nullMarker,
      bool? hasImage}) {
    Image? newImage = image ?? this.image;
    if (nullMarker ?? false) {
      newImage = null;
    }
    return OverviewState(
        status: status ?? this.status,
        marker: marker ?? this.marker,
        opacity: opacity ?? this.opacity,
        panelHeightClosed: panelHeightClosed ?? this.panelHeightClosed,
        panelHeightOpened: panelHeightOpened ?? this.panelHeightOpened,
        image: newImage,
        explore: explore ?? this.explore,
        isDraggable: isDraggable ?? this.isDraggable,
        hasImage: hasImage ?? this.hasImage);
  }
}
