import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod/river_pod.dart';
import '../viwes/disscusion_page.dart';


class PostActionsWidget extends ConsumerWidget {
  final String postId;
  final String userId;

  const PostActionsWidget({
    Key? key,
    required this.postId,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              ref.read(dissCussionProvider.notifier).toggleLike(postId, userId);
            },
            child: Icon(Icons.favorite, color: Colors.pink),
          ),
          SizedBox(width: 5),
          StreamBuilder<int>(
            stream: ref.read(dissCussionProvider.notifier).listenForLikesRT(postId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('0');
              }
              return Text(snapshot.data.toString());
            },
          ),
          SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return CommentInputWidget(postId: postId, userId: userId);
                },
              );
            },
            child: Icon(Icons.comment, color: Colors.grey),
          ),
          SizedBox(width: 5),
          StreamBuilder<int>(
            stream: ref.read(dissCussionProvider.notifier).listenForCommentsRT(postId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('0');
              }
              return Text(snapshot.data.toString());
            },
          ),
          Spacer(),
        ],
      ),
    );
  }
}