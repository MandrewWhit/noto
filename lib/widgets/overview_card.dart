import 'package:flutter/material.dart';

class OverviewCard extends StatefulWidget {
  OverviewCard({Key? key, this.url, required this.description})
      : super(key: key);

  String? url;
  String description;

  @override
  State<OverviewCard> createState() => _OverviewCardState();
}

class _OverviewCardState extends State<OverviewCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * .25,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Card(
              color: Colors.white,
              child: Text(widget.description),
            ),
            widget.url == null
                ? Image.asset('assets/car.gif', fit: BoxFit.fill)
                : Image.network(
                    widget.url ?? '',
                    fit: BoxFit.fill,
                  ),
          ],
        ),
      ),
    );
  }
}
