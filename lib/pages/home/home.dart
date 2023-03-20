import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowtowv1/bloc/auth/auth_bloc.dart';
import 'package:nowtowv1/bloc/auth/auth_events.dart';
import 'package:nowtowv1/bloc/auth/auth_state.dart';
import 'package:nowtowv1/pages/map/map.dart';
import 'package:nowtowv1/utils/location_service.dart';
import 'package:nowtowv1/utils/notow_colors.dart';
import 'package:nowtowv1/utils/route_generator.dart';
import 'package:nowtowv1/widgets/greeting.dart';
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
  final double _initFabHeight = 140.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 125.0;

  @override
  void initState() {
    super.initState();
    _fabHeight = _initFabHeight;
    LocationService.initializeLoctionService();
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    return Material(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: _body(),
            panelBuilder: (sc) => _panel(sc),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            }),
          ),

          // the fab
          Positioned(
            right: 20.0,
            bottom: _fabHeight,
            child: FloatingActionButton(
              child: Icon(
                Icons.gps_fixed,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
              backgroundColor: Colors.white,
            ),
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
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: sc,
          children: <Widget>[
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            SizedBox(
              height: 18.0,
            ),
            Greeting(),
            SizedBox(
              height: 36.0,
            ),
            SignOutButton(),
            SizedBox(height: 24.0),
          ],
        ));
  }

  Widget _body() {
    return TowMap();
  }
}
