import 'package:bfootlearn/Disscussion/widgets/post_action_widget.dart';
import 'package:bfootlearn/User/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod/river_pod.dart';
import '../provider/discuss_model.dart';
import 'disscusion_page.dart';

class DiscussionsDetailsPage extends ConsumerStatefulWidget {
  final String postId;

  DiscussionsDetailsPage({Key? key, required this.postId}) : super(key: key);

  @override
  _DiscussionsDetailsPageState createState() => _DiscussionsDetailsPageState();
}

class _DiscussionsDetailsPageState extends ConsumerState<DiscussionsDetailsPage> {
  late Future<Post> post;
  late Future<List<Comment>> comments;

  @override
  void initState() {
    super.initState();
    // Moved fetching logic to the build method
  }

  @override
  Widget build(BuildContext context) {
    final firestoreDiscussProvide = ref.read(dissCussionProvider);
    post = firestoreDiscussProvide.fetchPostById(widget.postId);
    comments = firestoreDiscussProvide.fetchCommentsByPostId(widget.postId);
    final TextEditingController _postController = TextEditingController();
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussion Details'),
      ),
      body: FutureBuilder<Post>(
        future: post,
        builder: (context, postSnapshot) {
          if (postSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (postSnapshot.hasError) {
            return Center(child: Text('Error fetching post'));
          }

          return Stack(
            children: [
              Column(
                children: [
                  PostCard(post: postSnapshot.data!),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(),
                  ),
                  StreamBuilder<List<Comment>>(
                    stream: firestoreDiscussProvide.listenForRepliesRT(widget.postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error fetching replies'));
                      }

                      return Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: double.infinity,
                        child: Card(
                          child: ListView.builder(
                            shrinkWrap: true, // This tells the ListView to only occupy space for its children
                           // physics: NeverScrollableScrollPhysics(), // Disables scrolling within this ListView
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ReplyWidget(reply: snapshot.data![index]);
                            },
                          ),
                        ),
                      );
                    },
                   ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: buildPostCommentField(
                  _postController,
                  user,
                  context,
                ), // This is your comment field at the bottom
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildPostCommentField(
      TextEditingController _postController, UserProvider user, BuildContext context
      ) {
    return Container(
     height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile4.jpg'), // Current user's profile image
              radius: 15,
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _postController,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  hintText: 'Post your comment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    ref.read(dissCussionProvider.notifier).addComment(widget.postId, Comment(
                      name: ref.read(userProvider).name,
                      time: DateTime.now().toString(),
                      content: value,
                      profileImage: ref.read(userProvider).photoUrl,
                    ));
                    //Navigator.pop(context);
                    _postController.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostCard extends ConsumerStatefulWidget {
  final Post post;

  PostCard({required this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  @override
  Widget build(BuildContext context) {
    final firestoreDiscussProvide = ref.read(dissCussionProvider);
    final user = ref.watch(userProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: widget.post.profileImage.isEmpty?
                AssetImage(
                  'assets/person_logo.png',
                ):Image.network(widget.post.profileImage).image,),
              title: Text(widget.post.name),
              subtitle: Text(timeAgo(widget.post.time)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(widget.post.content),
            ),
            PostActionsWidget(postId: widget.post.id ?? "", userId: user.uid)
          ],
        ),
      ),
    );
  }
  String timeAgo(String dateTimeStr) {
  DateTime dateTime = DateTime.parse(dateTimeStr);
  Duration difference = DateTime.now().difference(dateTime);

  if (difference.inDays > 365) {
    return '${(difference.inDays / 365).floor()} years ago';
  } else if (difference.inDays > 30) {
    return '${(difference.inDays / 30).floor()} months ago';
  } else if (difference.inDays > 7) {
    return '${(difference.inDays / 7).floor()} weeks ago';
  } else if (difference.inDays >= 1) {
    return '${difference.inDays} days ago';
  } else if (difference.inHours >= 1) {
    return '${difference.inHours} hours ago';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes} minutes ago';
  } else {
    return 'Just now';
  }
}
}

class ReplyWidget extends StatelessWidget {
  final Comment reply;

  ReplyWidget({required this.reply});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
       backgroundImage: reply.profileImage.isEmpty?
       AssetImage(
          'assets/person_logo.png',
       ):Image.network(reply.profileImage).image,
        radius: 15,
      ),
      title: Text(reply.name),
      subtitle: Text(reply.content),
      trailing: Text(timeAgo(reply.time)),
    );
  }
  String timeAgo(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
