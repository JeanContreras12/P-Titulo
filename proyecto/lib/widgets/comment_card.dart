import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCardScreen extends StatefulWidget {
  final snap;
  const CommentCardScreen({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<CommentCardScreen> createState() => _CommentCardScreenState();
}

class _CommentCardScreenState extends State<CommentCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
            radius: 18,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.snap['name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                          text: ' ${widget.snap['text']}',
                          style: const TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
