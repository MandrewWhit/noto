import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nowtowv1/utils/location_service.dart';

// class TowMap extends StatelessWidget {
//   const TowMap({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var locationStream = LocationService.positionStream;
//     return FlutterMap(
//       options: MapOptions(
//         //center: LatLng(30.2672, -97.7431),
//         center: LatLng(locationStream.),
//         zoom: 13,
//       ),
//       nonRotatedChildren: [
//         AttributionWidget.defaultWidget(
//           source: 'OpenStreetMap contributors',
//           onSourceTapped: () {},
//         ),
//       ],
//       children: [
//         TileLayer(
//           //urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//           urlTemplate: "https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png",
//           userAgentPackageName: 'dev.fleaflet.flutter_map.example',
//         ),
//         //MarkerLayer(markers: markers),
//       ],
//     );
//   }
// }

class TowMap extends StatefulWidget {
  TowMap({Key? key}) : super(key: key);

  @override
  State<TowMap> createState() => _TowMapState();
}

class _TowMapState extends State<TowMap> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        //center: LatLng(30.2672, -97.7431),
        center: LocationService.currentLocation ?? LatLng(30.2672, -97.7431),
        zoom: 13,
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
        MarkerLayer(markers: [
          Marker(
              point:
                  LocationService.currentLocation ?? LatLng(30.2672, -97.7431),
              builder: (context) => const Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 48.0,
                  ),
              height: 60),
        ]),
      ],
    );
  }
}
