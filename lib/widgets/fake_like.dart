import 'package:flutter/material.dart';

class FakeLike extends StatefulWidget {
  FakeLike({Key? key, required this.upVotes}) : super(key: key);

  final int upVotes;

  @override
  State<FakeLike> createState() => _FakeLikeState();
}

class _FakeLikeState extends State<FakeLike> {
  @override
  Widget build(BuildContext context) {
    int upVotes = widget.upVotes;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        children: [
          const Icon(
            Icons.favorite,
            color: Colors.grey,
          ),
          Text('$upVotes')
        ],
      ),
    );
  }
}
