import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowtowv1/bloc/overview/overview_bloc.dart';
import 'package:nowtowv1/bloc/overview/overview_events.dart';
import 'package:nowtowv1/models/marker.dart';
import 'package:nowtowv1/widgets/nearby_marker_card.dart';

class ExplorePanelInfo extends StatefulWidget {
  ExplorePanelInfo(
      {Key? key,
      required this.sc,
      required this.nearbyMarkers,
      required this.nearbyImages})
      : super(key: key);

  ScrollController sc;
  List<CustomMarker>? nearbyMarkers;
  List<Image>? nearbyImages;

  @override
  State<ExplorePanelInfo> createState() => _ExplorePanelInfoState();
}

class _ExplorePanelInfoState extends State<ExplorePanelInfo> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: widget.sc,
        itemCount: widget.nearbyMarkers!.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(children: <Widget>[
                  SizedBox(
                    height: 75,
                    width: MediaQuery.of(context).size.width * .75,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10, right: 8),
                      child: SizedBox.expand(
                        child: Text(
                          "Explore Nearby Tow Traps",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  //),
                ]),
                const SizedBox(
                  height: 40,
                ),
              ],
            );
          } else {
            return widget.nearbyMarkers == null
                ? const Center(child: CircularProgressIndicator())
                : NearbyMarkerCard(
                    marker: widget.nearbyMarkers![index - 1],
                    nearbyImage: widget.nearbyImages![index - 1]);
          }
        });

    //   SizedBox(
    //     height: 12.0,
    //   ),
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       Container(
    //         width: 30,
    //         height: 5,
    //         decoration: BoxDecoration(
    //             color: Colors.grey[300],
    //             borderRadius: BorderRadius.all(Radius.circular(12.0))),
    //       ),
    //     ],
    //   ),
    //   SizedBox(
    //     height: 15,
    //   ),
    //   Row(children: <Widget>[
    //     SizedBox(
    //       height: 75,
    //       width: MediaQuery.of(context).size.width * .75,
    //       child: const Padding(
    //         padding: EdgeInsets.only(left: 10, right: 8),
    //         child: SizedBox.expand(
    //           child: Text(
    //             "Explore Nearby Tow Traps",
    //             style: TextStyle(
    //                 color: Colors.indigo,
    //                 fontSize: 28,
    //                 fontWeight: FontWeight.bold),
    //           ),
    //         ),
    //       ),
    //     ),
    //     //),
    //   ]),
    //   const SizedBox(
    //     height: 40,
    //   ),
    //   widget.nearbyMarkers == null
    //       ? const Center(child: CircularProgressIndicator())
    //       : SizedBox(
    //           height: 500,
    //           child: ListView.builder(
    //             physics: const AlwaysScrollableScrollPhysics(),
    //             scrollDirection: Axis.vertical,
    //             shrinkWrap: true,
    //             itemCount: widget.nearbyMarkers!.length,
    //             itemBuilder: (context, index) {
    //               return NearbyMarkerCard(
    //                   marker: widget.nearbyMarkers![index],
    //                   nearbyImage: widget.nearbyImages![index]);
    //             },
    //           ),
    //         ),
    // ]);
  }
}
