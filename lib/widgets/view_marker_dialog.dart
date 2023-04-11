import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:nowtowv1/bloc/auth/auth_bloc.dart';
import 'package:nowtowv1/bloc/markers/markers_bloc.dart';
import 'package:nowtowv1/bloc/markers/markers_events.dart';
import 'package:nowtowv1/models/marker.dart';
import 'package:nowtowv1/utils/firebase_storage.dart';
import 'package:nowtowv1/utils/location_service.dart';
import 'package:nowtowv1/widgets/overview_card.dart';
import 'package:nowtowv1/widgets/update_marker.dart';
import 'package:quickalert/quickalert.dart';

class ViewMarkerDialog {
  static Future<dynamic> showViewMarkerDialog(
      BuildContext context, CustomMarker marker) async {
    Storage storage = Storage();
    bool userMarker = false;
    Widget displayWidget = RichText(
      text: TextSpan(
        text: marker.description,
        style: const TextStyle(color: Colors.black, fontSize: 11.0),
      ),
    );
    if (marker.uid == BlocProvider.of<AuthBloc>(context).state.user!.uid) {
      userMarker = true;
    }
    String customAsset = 'assets/car.gif';
    if (marker.imagePaths != null) {
      if (marker.imagePaths!.isNotEmpty) {
        customAsset = marker.imagePaths![0];
        customAsset = await storage.getImage(customAsset) ?? "";
        return OverviewCard(description: marker.description, url: customAsset);
      }
    }
    String message = "";
    return OverviewCard(description: marker.description, url: 'assets/car.gif');
    // return QuickAlert.show(
    //     context: context,
    //     type: QuickAlertType.custom,
    //     barrierDismissible: true,
    //     confirmBtnText: 'Ok',
    //     confirmBtnColor: Colors.green,
    //     showCancelBtn: userMarker,
    //     cancelBtnText: 'Update',
    //     cancelBtnTextStyle:
    //         TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
    //     customAsset: Image.network(customAsset),
    //     widget: displayWidget,
    //     onConfirmBtnTap: () async {
    //       Navigator.pop(context);
    //       return;
    //     },
    //     onCancelBtnTap: () async {
    //       UpdateMarkerDialog.showUpdateMarkerDialog(context, marker);
    //     });
  }
}
