import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:nowtowv1/bloc/auth/auth_bloc.dart';
import 'package:nowtowv1/bloc/markers/markers_bloc.dart';
import 'package:nowtowv1/bloc/markers/markers_events.dart';
import 'package:nowtowv1/bloc/overview/overview_bloc.dart';
import 'package:nowtowv1/bloc/overview/overview_events.dart';
import 'package:nowtowv1/models/marker.dart';
import 'package:nowtowv1/utils/location_service.dart';
import 'package:quickalert/quickalert.dart';

class UpdateMarkerDialog {
  static Future<dynamic> showUpdateMarkerDialog(
      BuildContext context, CustomMarker marker) async {
    String message = "";
    return QuickAlert.show(
        context: context,
        type: QuickAlertType.custom,
        barrierDismissible: true,
        confirmBtnText: 'Update',
        showCancelBtn: true,
        cancelBtnText: 'Delete',
        cancelBtnTextStyle:
            TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        customAsset: 'assets/notebook.gif',
        widget: TextFormField(
          minLines: 4,
          maxLines: null,
          decoration: InputDecoration(
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              hintText: 'Updated Description',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    width: 1, color: Color.fromARGB(255, 211, 220, 230)),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 1, color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(15),
              )),
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
            marker.description = message;
            BlocProvider.of<MarkersBloc>(context)
                .add(UpdateMarkerEvent(marker: marker, id: marker.id ?? ''));
            BlocProvider.of<MarkersBloc>(context).add(GetMarkersEvent(
                location: LocationService.currentLocation ??
                    LatLng(30.2672, -97.7431)));
          }
          Navigator.pop(context);
        },
        onCancelBtnTap: () async {
          if (BlocProvider.of<AuthBloc>(context).state.user != null) {
            marker.description = message;
            BlocProvider.of<MarkersBloc>(context)
                .add(DeleteMarkersEvent(ids: [marker.id ?? '']));
            BlocProvider.of<MarkersBloc>(context).add(GetMarkersEvent(
                location: LocationService.currentLocation ??
                    LatLng(30.2672, -97.7431)));
            BlocProvider.of<OverviewBloc>(context)
                .add(ToggleOpacityEvent(opacity: false, context: context));
          }
          Navigator.pop(context);
          await Future.delayed(const Duration(milliseconds: 1000));
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "Tow trap has been deleted!",
          );
        });
  }
}
