import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nowtowv1/bloc/markers/markers_events.dart';
import 'package:nowtowv1/bloc/markers/markers_state.dart';
import 'package:nowtowv1/bloc/overview/overview_events.dart';
import 'package:nowtowv1/bloc/overview/overview_state.dart';
import 'package:nowtowv1/models/marker.dart';
import 'package:nowtowv1/utils/firebase.dart';
import 'package:nowtowv1/utils/firebase_storage.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  OverviewBloc() : super(OverviewState()) {
    on<InitOverviewEvent>(_mapInitOverviewEventToState);
    on<SetMarkerEvent>(_mapSetMarkerEventToState);
    on<ToggleOpacityEvent>(_mapToggleOpacityEventToState);
  }
  Storage storage = Storage();

  void _mapInitOverviewEventToState(
      InitOverviewEvent event, Emitter<OverviewState> emit) async {
    emit(state.copyWith(status: OverviewStatus.loading));
    try {
      emit(
        state.copyWith(
            status: OverviewStatus.success,
            opacity: false,
            panelHeightClosed: 0),
      );
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: OverviewStatus.error));
    }
  }

  void _mapSetMarkerEventToState(
      SetMarkerEvent event, Emitter<OverviewState> emit) async {
    emit(state.copyWith(status: OverviewStatus.loading));
    try {
      Image? image;
      if (event.marker.imagePaths != null) {
        if (event.marker.imagePaths!.isNotEmpty) {
          var url = await storage.getImage(event.marker.imagePaths![0]) ?? "";
          image = Image.network(url);
        }
      }
      emit(
        state.copyWith(
            status: OverviewStatus.success,
            opacity: true,
            marker: event.marker,
            image: image),
      );
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: OverviewStatus.error));
    }
  }

  void _mapToggleOpacityEventToState(
      ToggleOpacityEvent event, Emitter<OverviewState> emit) async {
    emit(state.copyWith(status: OverviewStatus.loading));
    try {
      if (event.opacity) {
        emit(state.copyWith(
            status: OverviewStatus.success,
            opacity: event.opacity,
            panelHeightClosed: 150,
            panelHeightOpened: MediaQuery.of(event.context).size.height * .80));
      } else {
        emit(state.copyWith(
            status: OverviewStatus.success,
            opacity: event.opacity,
            panelHeightClosed: 0,
            panelHeightOpened: 0));
      }
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: OverviewStatus.error));
    }
  }
}
