import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:nowtowv1/bloc/auth/auth_bloc.dart';
import 'package:nowtowv1/bloc/auth/auth_events.dart';
import 'package:nowtowv1/bloc/markers/markers_bloc.dart';
import 'package:nowtowv1/bloc/markers/markers_events.dart';
import 'package:nowtowv1/bloc/markers/markers_state.dart';
import 'package:nowtowv1/bloc/overview/overview_bloc.dart';
import 'package:nowtowv1/bloc/overview/overview_events.dart';
import 'package:nowtowv1/bloc/overview/overview_state.dart';
import 'package:nowtowv1/models/marker.dart';
import 'package:nowtowv1/widgets/explore_panel_info.dart';
import 'package:nowtowv1/widgets/generic_button.dart';
import 'package:nowtowv1/widgets/greeting.dart';
import 'package:nowtowv1/widgets/sign_out_button.dart';
import 'package:nowtowv1/utils/firebase_storage.dart';
import 'package:nowtowv1/widgets/title_shimmer.dart';
import 'package:nowtowv1/widgets/update_marker.dart';
import 'package:provider/provider.dart';

class PanelInfo extends StatefulWidget {
  PanelInfo({Key? key, required this.sc}) : super(key: key);

  ScrollController sc;

  @override
  State<PanelInfo> createState() => _PanelInfoState();
}

class _PanelInfoState extends State<PanelInfo> {
  bool _isLiked = false;
  @override
  Widget build(BuildContext context) {
    double buttonSize = 30;
    return BlocBuilder<OverviewBloc, OverviewState>(
        bloc: BlocProvider.of<OverviewBloc>(context),
        builder: (context, state) {
          if (state.opacity != null) {
            bool isVisible = state.opacity ?? false;
            if (!isVisible) {
              widget.sc.animateTo(500,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            }
          }
          if ((BlocProvider.of<AuthBloc>(context).state.upVotes != null &&
                  state.marker?.id != null) &&
              BlocProvider.of<AuthBloc>(context)
                  .state
                  .upVotes!
                  .contains(state.marker!.id)) {
            _isLiked = true;
          } else {
            _isLiked = false;
          }
          bool userMarker = false;
          if (state.marker?.uid != null) {
            if (state.marker!.uid ==
                BlocProvider.of<AuthBloc>(context).state.user!.uid) {
              userMarker = true;
            }
          }
          Widget image = const Center(child: CircularProgressIndicator());
          bool hasImage = state.hasImage ?? true;
          if (!hasImage) {
            image = Container();
          }
          if (state.image != null) {
            image = state.image as Widget;
          }
          String description = state.marker?.description ?? "";
          String name = state.marker?.name ?? "";
          bool explore = state.explore ?? false;
          return explore
              ? BlocBuilder<MarkersBloc, MarkersState>(
                  bloc: BlocProvider.of<MarkersBloc>(context),
                  builder: (context, state) {
                    return ExplorePanelInfo(
                      nearbyMarkers: BlocProvider.of<MarkersBloc>(context)
                          .state
                          .nearbyMarkers,
                      nearbyImages: BlocProvider.of<MarkersBloc>(context)
                          .state
                          .nearbyImages,
                      sc: widget.sc,
                    );
                  })
              : name == null
                  ? const SizedBox(child: CircularProgressIndicator())
                  : ListView(
                      controller: widget.sc,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<OverviewBloc>(context)
                                      .add(const ExploreEvent(explore: true));
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(children: <Widget>[
                          SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10, right: 8),
                              child: SizedBox.expand(
                                // child: FittedBox(
                                //fit: BoxFit.contain,
                                child: name == ""
                                    ? TitleShimmer()
                                    : Text(
                                        name,
                                        style: const TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                          ),
                          //),
                        ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 20, top: 5),
                              child: name == ""
                                  ? Container()
                                  : GestureDetector(
                                      child: LikeButton(
                                        isLiked: _isLiked,
                                        size: buttonSize,
                                        // circleColor: const CircleColor(
                                        //     start: Color(0xff00ddff), end: Color(0xff0099cc)),
                                        circleColor: const CircleColor(
                                            start: Colors.redAccent,
                                            end: Colors.indigo),
                                        bubblesColor: const BubblesColor(
                                          dotPrimaryColor: Color(0xff33b5e5),
                                          dotSecondaryColor: Color(0xff0099cc),
                                        ),
                                        likeBuilder: (bool isLiked) {
                                          return Icon(
                                            Icons.favorite,
                                            color: isLiked
                                                ? Colors.indigoAccent
                                                : Colors.grey,
                                            size: buttonSize,
                                          );
                                        },
                                        likeCount: state.marker?.upVotes ?? 0,
                                        onTap: (bool isLiked) {
                                          setState(() {
                                            _isLiked = !isLiked;
                                          });
                                          return onLikeButtonTapped(isLiked,
                                              state.marker ?? CustomMarker());
                                        },
                                        countBuilder: (int? count, bool isLiked,
                                            String text) {
                                          var color = isLiked
                                              ? Colors.indigoAccent
                                              : Colors.grey;
                                          Widget result;
                                          if (count == 0) {
                                            result = Text(
                                              "like",
                                              style: TextStyle(color: color),
                                            );
                                          } else
                                            result = Text(
                                              text,
                                              style: TextStyle(color: color),
                                            );
                                          return result;
                                        },
                                      ),
                                    ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        //Greeting(),
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 8, right: 8, bottom: 8),
                          child: Text(
                            "Description",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              description,
                              style: TextStyle(fontSize: 18),
                            )),
                        SizedBox(
                          height: 36.0,
                        ),
                        image,
                        SizedBox(
                          height: 36.0,
                        ),
                        //NewMarkerButton(),
                        userMarker
                            ? Padding(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: GestureDetector(
                                  child: GenericButton(text: "Update"),
                                  onTap: () {
                                    if (state.marker != null) {
                                      UpdateMarkerDialog.showUpdateMarkerDialog(
                                          context,
                                          state.marker ?? CustomMarker());
                                    }
                                  },
                                ),
                              )
                            : Container(),
                        SignOutButton(),
                        SizedBox(height: 24.0),
                        Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Center(
                                child: Text(
                              "Questions or Feedback? Call Us...\n806-922-1112",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.indigo),
                            ))),
                        SizedBox(height: 24.0),
                        // Center(
                        //   child: Text(
                        //     "More Coming Soon...",
                        //     style: TextStyle(
                        //         color: Colors.indigo,
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 24),
                        //   ),
                        // ),
                      ],
                    );
        });
  }

  Future<bool> onLikeButtonTapped(bool isLiked, CustomMarker marker) async {
    if (!isLiked) {
      var upVotes = marker.upVotes ?? 0;
      upVotes += 1;
      marker.upVotes = upVotes;
      BlocProvider.of<MarkersBloc>(context)
          .add(UpdateMarkerEvent(marker: marker, id: marker.id ?? ""));
      // BlocProvider.of<OverviewBloc>(context)
      //     .add(const LikeButtonEvent(upVote: true));
      BlocProvider.of<AuthBloc>(context)
          .add(UpVoteMarkerEvent(id: marker.id ?? ""));
    } else {
      var upVotes = marker.upVotes ?? 0;
      upVotes -= 1;
      marker.upVotes = upVotes;
      BlocProvider.of<MarkersBloc>(context)
          .add(UpdateMarkerEvent(marker: marker, id: marker.id ?? ""));
      // BlocProvider.of<OverviewBloc>(context)
      //     .add(const LikeButtonEvent(upVote: false));
      BlocProvider.of<AuthBloc>(context)
          .add(DownVoteMarkerEvent(id: marker.id ?? ""));
    }
    return !isLiked;
  }
}
