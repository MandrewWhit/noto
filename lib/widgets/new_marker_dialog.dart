import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:nowtowv1/bloc/auth/auth_bloc.dart';
import 'package:nowtowv1/bloc/markers/markers_bloc.dart';
import 'package:nowtowv1/bloc/markers/markers_events.dart';
import 'package:nowtowv1/models/marker.dart';
import 'package:nowtowv1/utils/location_service.dart';
import 'package:nowtowv1/widgets/generic_button.dart';
import 'package:nowtowv1/widgets/image_wrapper.dart';
import 'package:quickalert/quickalert.dart';

class AddMarkerDialog {
  static String message = "";
  static String title = "";
  ImageWrapper imageWrapper = ImageWrapper(path: 'assets/camera21.png');

  showAddMarkerDialog(BuildContext context, LatLng point) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Report Tow Trap",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo),
                  ),
                ),
                imageWrapper,
                const Center(
                    child: Text(
                  "Click camera to add a photo",
                  style: TextStyle(
                      color: Colors.indigo, fontWeight: FontWeight.bold),
                )),
                Padding(
                  padding: EdgeInsets.only(top: 25, bottom: 10),
                  child: TextFormField(
                    minLines: 1,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        hintText: 'Name/Title',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 211, 220, 230)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(15),
                        )),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) => title = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25, bottom: 10),
                  child: TextFormField(
                    minLines: 8,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        hintText: 'Tow Trap Description',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 211, 220, 230)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(15),
                        )),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) => message = value,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _submit(context, point, imageWrapper.path);
                  },
                  child: GenericButton(
                    text: "Submit",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _submit(
      BuildContext context, LatLng point, String imagePath) async {
    bool submitImage = false;
    if (imagePath != 'assets/camera21.png') {
      submitImage = true;
    }
    if (title.isEmpty) {
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Please input a Name/Title',
      );
      return;
    }
    if (message.isEmpty) {
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Please input a description',
      );
      return;
    }
    if (BlocProvider.of<AuthBloc>(context).state.user != null) {
      if (submitImage) {
        BlocProvider.of<MarkersBloc>(context).add(CreateMarkerEvent(
            user: BlocProvider.of<AuthBloc>(context).state.user,
            marker: CustomMarker(
                name: title,
                description: message,
                lat: point.latitude,
                lng: point.longitude,
                imagePaths: [imagePath])));
      } else {
        BlocProvider.of<MarkersBloc>(context).add(CreateMarkerEvent(
            user: BlocProvider.of<AuthBloc>(context).state.user,
            marker: CustomMarker(
                name: title,
                description: message,
                lat: point.latitude,
                lng: point.longitude)));
      }
      BlocProvider.of<MarkersBloc>(context).add(GetMarkersEvent(
          location:
              LocationService.currentLocation ?? LatLng(30.2672, -97.7431)));
    }
    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 1000));
    //await QuickAlert.show(
    // context: context,
    // type: QuickAlertType.success,
    // text: "Tow trap location has been submitted!.",
    //);
  }
}
