import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:nowtowv1/models/marker.dart';

@immutable
abstract class OverviewEvent {
  const OverviewEvent();

  List<Object> get props => [];
}

class InitOverviewEvent extends OverviewEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Init Event';
}

class ExploreEvent extends OverviewEvent {
  const ExploreEvent({required this.explore});

  final bool explore;

  @override
  List<Object> get props => [explore];

  @override
  String toString() => 'Explore Event';
}

class SetDraggableEvent extends OverviewEvent {
  const SetDraggableEvent({required this.isDraggable});

  final bool isDraggable;

  @override
  List<Object> get props => [isDraggable];

  @override
  String toString() => 'Set Draggable Event';
}

class SetMarkerEvent extends OverviewEvent {
  const SetMarkerEvent({required this.marker});

  final CustomMarker marker;

  @override
  List<Object> get props => [marker];

  @override
  String toString() => 'Set Marker Event';
}

class ToggleOpacityEvent extends OverviewEvent {
  const ToggleOpacityEvent({required this.opacity, required this.context});

  final bool opacity;
  final BuildContext context;

  @override
  List<Object> get props => [opacity, context];

  @override
  String toString() => 'Toggle Opacity Event';
}
