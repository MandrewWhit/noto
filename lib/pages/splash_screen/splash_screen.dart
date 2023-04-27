import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:nowtowv1/bloc/markers/markers_bloc.dart';
import 'package:nowtowv1/bloc/markers/markers_events.dart';
import 'package:nowtowv1/bloc/markers/markers_state.dart';
import 'package:nowtowv1/pages/home/home.dart';
import 'package:nowtowv1/utils/location_service.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initMarkers();
  }

  Future initMarkers() async {
    await LocationService.initializeLoctionService();
    BlocProvider.of<MarkersBloc>(context).add(AddGeofenceEvent(
        location:
            LocationService.currentLocation ?? LatLng(30.2672, -97.7431)));
    return;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarkersBloc, MarkersState>(
        bloc: BlocProvider.of<MarkersBloc>(context),
        builder: (context, state) {
          return state.markers != null
              ? HomePage()
              : MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Noto',
                  theme: ThemeData(
                    primaryColor: Colors.indigo,
                    primarySwatch: Colors.indigo,
                  ),
                  initialRoute: '/',
                  home: Scaffold(
                    body: Center(
                      child: Image.asset('assets/drive-blue.gif'),
                    ),
                  ),
                );
        });
  }
}
