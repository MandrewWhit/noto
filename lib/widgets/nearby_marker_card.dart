import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowtowv1/bloc/overview/overview_bloc.dart';
import 'package:nowtowv1/bloc/overview/overview_events.dart';
import 'package:nowtowv1/models/marker.dart';
import 'package:nowtowv1/utils/firebase_storage.dart';
import 'package:nowtowv1/widgets/fake_like.dart';

class NearbyMarkerCard extends StatefulWidget {
  NearbyMarkerCard({Key? key, required this.marker, required this.nearbyImage})
      : super(key: key);

  final CustomMarker marker;
  final Image nearbyImage;

  @override
  State<NearbyMarkerCard> createState() => _NearbyMarkerCardState();
}

class _NearbyMarkerCardState extends State<NearbyMarkerCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<OverviewBloc>(context)
              .add(SetMarkerEvent(marker: widget.marker));
          BlocProvider.of<OverviewBloc>(context)
              .add(const ExploreEvent(explore: false));
        },
        child: Container(
          height: 225,
          child: Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: const EdgeInsets.all(10),
              child:
                  Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                widget.nearbyImage,
                Container(
                  color: Colors.white,
                  height: 75,
                  width: 1000,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 8, top: 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FakeLike(upVotes: widget.marker.upVotes ?? 0)
                              ],
                            ),
                            Text(
                              widget.marker.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ])),
                )
              ])),
        ),
      ),
    );
  }
}
