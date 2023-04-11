import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:nowtowv1/bloc/mapbloc/map_events.dart';
import 'package:nowtowv1/bloc/mapbloc/map_state.dart';
import 'package:nowtowv1/models/marker.dart';
import 'package:nowtowv1/utils/firebase.dart';
import 'package:nowtowv1/utils/location_service.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState()) {
    on<ToggleEvent>(_mapToggleEventToState);
    on<SetMapControllerEvent>(_mapSetEventToState);
    on<RecenterEvent>(_mapRecenterEventToState);
    on<SetLocationEvent>(_mapSetLocationEventToState);
  }

  void _mapToggleEventToState(ToggleEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(status: MapStatus.loading));
    try {
      emit(state.copyWith(
          status: MapStatus.success, showMarkerDesc: !state.showMarkerDesc));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: MapStatus.error));
    }
  }

  void _mapSetEventToState(
      SetMapControllerEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(status: MapStatus.loading));
    try {
      emit(
        state.copyWith(
            status: MapStatus.success, mapController: event.mapController),
      );
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: MapStatus.error));
    }
  }

  void _mapRecenterEventToState(
      RecenterEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(status: MapStatus.loading));
    try {
      emit(state.copyWith(status: MapStatus.success));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: MapStatus.error));
    }
  }

  void _mapSetLocationEventToState(
      SetLocationEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(status: MapStatus.loading));
    try {
      emit(state.copyWith(
          status: MapStatus.success, locationLoaded: event.locationLoaded));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: MapStatus.error));
    }
  }
}
