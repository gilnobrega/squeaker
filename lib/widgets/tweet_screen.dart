import 'package:flutter/material.dart';
import 'package:squeaker/widgets/watch_scaffold.dart';

class TweetScreen extends StatelessWidget {
  final String? id;
  final String user;
  final String content;
  final ScrollController? controller;

  const TweetScreen({
    super.key,
    this.id,
    this.controller,
    required this.user,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return WatchScaffold(
      controller: controller,
      title: Text(
        user,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      body: Center(
        child: Text(
          content,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          textAlign: TextAlign.start,
        ),
      ),
      actions: const [
        Icon(
          Icons.star,
          color: Colors.white,
        ),
        Icon(
          Icons.arrow_upward_sharp,
          color: Colors.white,
        ),
      ],
    );
  }
}
