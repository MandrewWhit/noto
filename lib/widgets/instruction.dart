import 'package:flutter/material.dart';

class Instruction extends StatelessWidget {
  const Instruction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width * .75,
      child: Card(
        color: const Color.fromRGBO(120, 101, 159, 0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              "Tap a pin to see tow trap details or tap anywhere to report a new tow trap.",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
