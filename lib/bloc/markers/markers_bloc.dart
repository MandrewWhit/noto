import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nowtowv1/bloc/markers/markers_events.dart';
import 'package:nowtowv1/bloc/markers/markers_state.dart';
import 'package:nowtowv1/models/marker.dart';
import 'package:nowtowv1/utils/firebase.dart';
import 'package:nowtowv1/utils/firebase_storage.dart';

class MarkersBloc extends Bloc<MarkersEvent, MarkersState> {
  MarkersBloc({required this.service, required this.storage})
      : super(MarkersState()) {
    on<CreateMarkerEvent>(_mapCreateEventToState);
    on<GetMarkersEvent>(_mapGetEventToState);
    on<UpdateMarkerEvent>(_mapUpdateEventToState);
    on<DeleteMarkersEvent>(_mapDeleteEventToState);
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
      log(stacktrace.toString());
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
      log(stacktrace.toString());
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
      log(stacktrace.toString());
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
            break;
          }
        }
      }
      emit(
        state.copyWith(status: MarkersStatus.success, markers: newMarkers),
      );
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: MarkersStatus.error));
    }
  }
}
