import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nowtowv1/bloc/auth/auth_bloc.dart';
import 'package:nowtowv1/bloc/mapbloc/map_bloc.dart';
import 'package:nowtowv1/bloc/mapbloc/map_state.dart';
import 'package:nowtowv1/bloc/markers/markers_bloc.dart';
import 'package:nowtowv1/bloc/markers/markers_events.dart';
import 'package:nowtowv1/bloc/markers/markers_state.dart';
import 'package:nowtowv1/bloc/overview/overview_bloc.dart';
import 'package:nowtowv1/bloc/overview/overview_events.dart';
import 'package:nowtowv1/bloc/overview/overview_state.dart';
import 'package:nowtowv1/data_structures/custom_stack.dart';
import 'package:nowtowv1/models/marker.dart';
import 'package:nowtowv1/utils/location_service.dart';
import 'package:nowtowv1/widgets/add_marker.dart';
import 'package:nowtowv1/widgets/generic_shimmer.dart';
import 'package:nowtowv1/widgets/new_marker_dialog.dart';
import 'package:nowtowv1/widgets/view_marker_dialog.dart';
import 'package:shimmer/shimmer.dart';

class TowMap extends StatefulWidget {
  TowMap({Key? key, required this.mapController}) : super(key: key);

  MapController mapController;

  @override
  State<TowMap> createState() => _TowMapState();
}

class _TowMapState extends State<TowMap> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<OverviewBloc>(context)
        .add(const ExploreEvent(explore: true));
    BlocProvider.of<OverviewBloc>(context).add(InitOverviewEvent());
  }

  List<Marker> getMarkers(BuildContext context) {
    List<Marker> markers = [];
    List<CustomMarker> customMarkers =
        BlocProvider.of<MarkersBloc>(context).state.markers ?? [];
    for (int i = 0; i < customMarkers.length; i++) {
      markers.add(
        Marker(
          point: LatLng(customMarkers[i].lat, customMarkers[i].lng),
          height: 100,
          builder: (context) => GestureDetector(
            child: GestureDetector(
              onTap: () {
                if (BlocProvider.of<OverviewBloc>(context).state.marker !=
                    null) {
                  String name =
                      BlocProvider.of<OverviewBloc>(context).state.marker!.name;
                  if (name != "") {
                    BlocProvider.of<OverviewBloc>(context)
                        .add(SetMarkerEvent(marker: customMarkers[i]));
                  }
                } else {
                  BlocProvider.of<OverviewBloc>(context)
                      .add(SetMarkerEvent(marker: customMarkers[i]));
                }
              },
              // child: Icon(
              //   Icons.location_pin,
              //   color: Colors.indigo,
              //   size: 48.0,
              // ),
              child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/marker-transparent.png',
                    width: 100,
                    height: 100,
                  )),
            ),
          ),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    // BlocProvider.of<MarkersBloc>(context).add(GetMarkersEvent(
    //     location:
    //         LocationService.currentLocation ?? LatLng(30.2672, -97.7431)));
    return BlocBuilder<MarkersBloc, MarkersState>(
      bloc: BlocProvider.of<MarkersBloc>(context),
      builder: (context, state) {
        MyStack<CustomMarker> nearbyMarkers = MyStack<CustomMarker>();
        MyStack<double> nearbyMarkersDist = MyStack<double>();
        if (LocationService.currentLocation != null) {
          if (state.markers != null) {
            LatLng? userLoc = LocationService.currentLocation;
            for (int i = 0; i < state.markers!.length; i++) {
              var newDistance = sqrt(
                  pow((userLoc!.latitude - state.markers![i].lat), 2) +
                      pow((userLoc.longitude - state.markers![i].lng), 2));
              for (int j = 0; j < nearbyMarkers.getSize; j++) {
                if (newDistance < nearbyMarkersDist.getAt(j)) {
                  nearbyMarkers.insertAt(j, state.markers![i]);
                  nearbyMarkersDist.insertAt(j, newDistance);
                  break;
                }
              }
              if (nearbyMarkers.getSize < 5) {
                nearbyMarkers.pushEnd(state.markers![i]);
                nearbyMarkersDist.pushEnd(newDistance);
              }
            }
          }
        }
        BlocProvider.of<OverviewBloc>(context)
            .add(ToggleOpacityEvent(opacity: true, context: context));
        List<Marker> towMarkers = getMarkers(context);
        return LocationService.currentLocation == null
            ? GenericShimmer()
            : FlutterMap(
                mapController: widget.mapController,
                options: MapOptions(
                  onTap: (tapPosition, point) {
                    // final state = BlocProvider.of<MarkersBloc>(context).state;
                    // bool markerTap = false;
                    // if (state.markers != null) {
                    //   for (int i = 0; i < state.markers!.length; i++) {
                    //     if ((state.markers![i].lat < point.latitude + 0.001 &&
                    //             state.markers![i].lat >
                    //                 point.latitude - 0.001) &&
                    //         (state.markers![i].lng < point.longitude + 0.001 &&
                    //             state.markers![i].lng >
                    //                 point.longitude - 0.001)) {
                    //       markerTap = true;
                    //       //ViewMarkerDialog.showViewMarkerDialog(
                    //       //    context, state.markers![i]);
                    //       BlocProvider.of<OverviewBloc>(context).add(
                    //           ToggleOpacityEvent(
                    //               opacity: true, context: context));
                    //       BlocProvider.of<OverviewBloc>(context)
                    //           .add(SetMarkerEvent(marker: state.markers![i]));
                    //       break;
                    //     }
                    //   }
                    // }
                    bool markerTap = false;
                    if (!markerTap) {
                      //BlocProvider.of<OverviewBloc>(context).add(
                      //    ToggleOpacityEvent(opacity: false, context: context));
                      //NewMarkerDialog.showNewMarkerDialog(context, point);
                      var dialog = AddMarkerDialog();
                      dialog.showAddMarkerDialog(context, point);
                    }
                  },
                  //center: LatLng(30.2672, -97.7431),
                  interactiveFlags:
                      InteractiveFlag.all & ~InteractiveFlag.rotate,
                  center: LocationService.currentLocation ??
                      LatLng(30.2672, -97.7431),
                  zoom: 13,
                  //
                ),
                nonRotatedChildren: [
                  AttributionWidget.defaultWidget(
                    source: 'OpenStreetMap contributors',
                    onSourceTapped: () {},
                  ),
                ],
                children: [
                  TileLayer(
                      //urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      //urlTemplate: "https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png",
                      // urlTemplate:
                      //     "https://api.mapbox.com/styles/v1/andrewwhit99/clfg66io3000y01nxck6woufq/wmts?access_token=pk.eyJ1IjoiYW5kcmV3d2hpdDk5IiwiYSI6ImNsZmc2MnlsZjA0MXgzcXF4Z2o4eXI4dWwifQ.YK0li1kJBWf_VYqsKP4u8w",
                      // userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                      urlTemplate:
                          'https://api.mapbox.com/styles/v1/andrewwhit99/clfg66io3000y01nxck6woufq/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYW5kcmV3d2hpdDk5IiwiYSI6ImNsZmc2MnlsZjA0MXgzcXF4Z2o4eXI4dWwifQ.YK0li1kJBWf_VYqsKP4u8w',
                      additionalOptions: {
                        'accessToken':
                            'pk.eyJ1IjoiYW5kcmV3d2hpdDk5IiwiYSI6ImNsZmc2MnlsZjA0MXgzcXF4Z2o4eXI4dWwifQ.YK0li1kJBWf_VYqsKP4u8w',
                        'id': 'clfg66io3000y01nxck6woufq'
                      }),
                  //MarkerLayer(markers: towMarkers
                  //     [
                  //   Marker(
                  //       point: towMarkers[1].point,
                  //       builder: (context) => GestureDetector(
                  //             onTap: () {
                  //               int a = 0;
                  //             },
                  //             child: const Icon(
                  //               Icons.location_on,
                  //               color: Colors.blue,
                  //               size: 48.0,

                  //           ),
                  //       height: 60),
                  // ]),
                  //  ),
                  CircleLayer(
                    circles: [
                      CircleMarker(
                          point: LocationService.currentLocation ??
                              LatLng(30.2672, -97.7431),
                          radius: 12.5,
                          color: Colors.indigoAccent,
                          borderColor: Colors.white,
                          borderStrokeWidth: 5)
                    ],
                  ),
                  MarkerLayer(markers: towMarkers),
                ],
              );
      },
    );
  }
}
