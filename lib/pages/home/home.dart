import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:nowtowv1/bloc/auth/auth_bloc.dart';
import 'package:nowtowv1/bloc/auth/auth_events.dart';
import 'package:nowtowv1/bloc/auth/auth_state.dart';
import 'package:nowtowv1/bloc/overview/overview_bloc.dart';
import 'package:nowtowv1/bloc/overview/overview_state.dart';
import 'package:nowtowv1/pages/map/map.dart';
import 'package:nowtowv1/utils/location_service.dart';
import 'package:nowtowv1/utils/notow_colors.dart';
import 'package:nowtowv1/utils/route_generator.dart';
import 'package:nowtowv1/widgets/greeting.dart';
import 'package:nowtowv1/widgets/instruction.dart';
import 'package:nowtowv1/widgets/new_marker_button.dart';
import 'package:nowtowv1/widgets/overview_card.dart';
import 'package:nowtowv1/widgets/panel_info.dart';
import 'package:nowtowv1/widgets/sign_out_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// class Home extends StatelessWidget {
//   final double _initFabHeight = 120.0;
//   double _fabHeight = 0;
//   double _panelHeightOpen = 0;
//   double _panelHeightClosed = 95.0;

//   @override
//   Widget build(BuildContext context) {
//     if (BlocProvider.of<AuthBloc>(context).state.firstname == null ||
//         BlocProvider.of<AuthBloc>(context).state.lastname == null) {
//       BlocProvider.of<AuthBloc>(context).add(GetNameEvent());
//     }
//     return Scaffold(
//       body: Stack(children: <Widget>[
//         SlidingUpPanel(
//           body: TowMap(),
//           panel: ListView(
//             children: const <Widget>[Greeting(), SignOutButton()],
//           ),
//         ),
//       ]),
//     );
//   }
// }

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/services.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double _initFabHeight = 174.0;
  double _fabHeight = 0;
  //double _panelHeightOpen = 0;
  //double _panelHeightClosed = 125.0;
  double _panelHeightClosed = 0;

  @override
  void initState() {
    super.initState();
    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    MapController mapController = MapController();
    _fabHeight = MediaQuery.of(context).size.height * .85;
    final userBloc = BlocProvider.of<AuthBloc>(context);
    if (userBloc.state.firstname == null || userBloc.state.lastname == null) {
      userBloc.add(GetNameEvent());
    }
    //_panelHeightOpen = MediaQuery.of(context).size.height * .80;
    return Scaffold(
      body: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            //OverviewCard(description: ''),
            BlocBuilder<OverviewBloc, OverviewState>(
                bloc: BlocProvider.of<OverviewBloc>(context),
                builder: (context, state) {
                  return SlidingUpPanel(
                    isDraggable: state.isDraggable ?? true,
                    maxHeight: state.panelHeightOpened ?? 0,
                    minHeight: state.panelHeightClosed ?? 0,
                    parallaxEnabled: true,
                    parallaxOffset: .5,
                    body: TowMap(mapController: mapController),
                    panelBuilder: (sc) => _panel(sc),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0)),
                    // onPanelSlide: (double pos) => setState(() {
                    //   _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                    //       _initFabHeight;
                    onPanelSlide: (double pos) {},
                  );
                }),
            // the fab
            Positioned(
              right: 20.0,
              bottom: _fabHeight,
              child: FloatingActionButton(
                child: Icon(
                  Icons.gps_fixed,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  mapController.move(
                      LocationService.currentLocation ??
                          LatLng(30.2672, -97.7431),
                      13);
                },
                backgroundColor: Colors.white,
              ),
            ),
            Positioned(
              left: 20,
              bottom: _fabHeight,
              child: const Instruction(),
            ),
            Positioned(
                top: 0,
                child: ClipRRect(
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).padding.top,
                          color: Colors.transparent,
                        )))),
          ],
        ),
      ),
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: PanelInfo(
          sc: sc,
        ));
  }
}
