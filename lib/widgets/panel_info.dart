import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowtowv1/bloc/auth/auth_bloc.dart';
import 'package:nowtowv1/bloc/overview/overview_bloc.dart';
import 'package:nowtowv1/bloc/overview/overview_state.dart';
import 'package:nowtowv1/models/marker.dart';
import 'package:nowtowv1/widgets/generic_button.dart';
import 'package:nowtowv1/widgets/greeting.dart';
import 'package:nowtowv1/widgets/sign_out_button.dart';
import 'package:nowtowv1/utils/firebase_storage.dart';
import 'package:nowtowv1/widgets/update_marker.dart';
import 'package:provider/provider.dart';

class PanelInfo extends StatefulWidget {
  PanelInfo({Key? key, required this.sc}) : super(key: key);

  ScrollController sc;

  @override
  State<PanelInfo> createState() => _PanelInfoState();
}

class _PanelInfoState extends State<PanelInfo> {
  @override
  Widget build(BuildContext context) {
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
          bool userMarker = false;
          if (state.marker?.uid != null) {
            if (state.marker!.uid ==
                BlocProvider.of<AuthBloc>(context).state.user!.uid) {
              userMarker = true;
            }
          }
          Widget image = Container();
          if (state.image != null) {
            image = state.image as Widget;
          }
          String description = state.marker?.description ?? "";
          String name = state.marker?.name ?? "";
          return ListView(
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
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  ),
                ],
              ),
              SizedBox(
                height: 18.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 75.0,
              ),
              //Greeting(),
              const Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  "Description:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                context, state.marker ?? CustomMarker());
                          }
                        },
                      ),
                    )
                  : Container(),
              SignOutButton(),
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
}
