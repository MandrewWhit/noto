import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:nowtowv1/bloc/auth/auth_bloc.dart';
import 'package:nowtowv1/bloc/markers/markers_bloc.dart';
import 'package:nowtowv1/bloc/markers/markers_events.dart';
import 'package:nowtowv1/models/marker.dart';
import 'package:nowtowv1/utils/location_service.dart';
import 'package:quickalert/quickalert.dart';

class NewMarkerDialog {
  static Future<dynamic> showNewMarkerDialog(
      BuildContext context, LatLng point) async {
    String message = "";
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'Submit',
      customAsset: 'assets/1.png',
      widget: TextFormField(
        decoration: const InputDecoration(
          alignLabelWithHint: true,
          hintText: 'Tow Trap Description',
        ),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.multiline,
        onChanged: (value) => message = value,
      ),
      onConfirmBtnTap: () async {
        if (message.isEmpty) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Please input a description',
          );
          return;
        }
        if (BlocProvider.of<AuthBloc>(context).state.user != null) {
          BlocProvider.of<MarkersBloc>(context).add(CreateMarkerEvent(
              user: BlocProvider.of<AuthBloc>(context).state.user,
              marker: CustomMarker(
                  description: message,
                  lat: point.latitude,
                  lng: point.longitude)));
          BlocProvider.of<MarkersBloc>(context).add(GetMarkersEvent(
              location: LocationService.currentLocation ??
                  LatLng(30.2672, -97.7431)));
        }
        Navigator.pop(context);
        await Future.delayed(const Duration(milliseconds: 1000));
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Tow trap location has been submitted!.",
        );
      },
    );
  }
}
