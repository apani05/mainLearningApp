import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod/river_pod.dart';
import '../provider/discuss_model.dart';
import '../widgets/post_action_widget.dart';
import 'disscuss_details_page.dart';

class DisscussionPage extends ConsumerStatefulWidget {
  const DisscussionPage({super.key});

  @override
  DisscussionPageState createState() => DisscussionPageState();
}

class DisscussionPageState extends ConsumerState<DisscussionPage> {
  List<Post> posts = [];
  final TextEditingController _postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dissCussionProvider.notifier).fetchPosts();
    });
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(dissCussionProvider.select((provider) => provider.isLoading));
    final posts = ref.watch(dissCussionProvider.select((provider) => provider.posts));
    final user = ref.watch(userProvider);
    return isLoading?
    const Center(child: CircularProgressIndicator()):
    Padding(
       padding: const EdgeInsets.all(8.0),
       child: Column(
         children: [
           Row(
             children: [
               CircleAvatar(
                 backgroundImage: NetworkImage(
                    user.photoUrl,
                 ), // Replace with your profile image asset
                 radius: 20,
               ),
               SizedBox(width: 10),
               Expanded(
                 child: TextField(
                   controller: _postController,
                   textInputAction: TextInputAction.send,
                   decoration: InputDecoration(
                     hintText: "Start a new discussion",
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(20),
                       borderSide: BorderSide.none,
                     ),
                     filled: true,
                     fillColor: Colors.grey[200],
                     contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                   ),
                   onSubmitted: (value) {
                     if (value.trim().isEmpty) {
                       // Optionally handle empty input case, e.g., show a Snackbar message
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Please enter some text before posting.')),
                       );
                       return;
                     }
                     final newPost = Post(
                       name: user.name,
                       profileImage: user.photoUrl,
                       content: value,
                       time: DateTime.now().toString(), // Convert to Timestamp in `toMap` method
                       likes: 0,
                       comments: 0,
                     );
                     ref.read(dissCussionProvider.notifier).addPost(newPost).then((_) {
                       // Success feedback
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Post added successfully')),
                       );
                        _postController.clear();
                     }).catchError((error) {
                       // Error feedback
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text('Failed to add post: $error')),
                       );
                     });
                   },
                 ),
               ),
             ],
           ),
           Expanded(
             child: ListView.builder(
               itemCount: posts.length,
               itemBuilder: (context, index) {
                 return PostCard(post: posts[index]);
               },
             ),
           ),
         ],
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

    final user = ref.watch(userProvider);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiscussionsDetailsPage(postId: widget.post.id??"",),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(widget.post.profileImage),
                ),
                title: Text(widget.post.name.isEmpty ? 'Anonymous' : widget.post.name),
                subtitle: Row(
                  children: [
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    //   decoration: BoxDecoration(
                    //     color: Colors.blue,
                    //     borderRadius: BorderRadius.circular(12.0),
                    //   ),
                    //   child: Text(
                    //     post.likesList,
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    // ),
                    SizedBox(width: 10),
                    Text(widget.post.time),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(widget.post.content),
              ),
              PostActionsWidget(postId: widget.post.id??"", userId: user.uid),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentInputWidget extends ConsumerStatefulWidget {
  final String postId;
  final String userId;

  const CommentInputWidget({Key? key, required this.postId, required this.userId}) : super(key: key);

  @override
  _CommentInputWidgetState createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends ConsumerState<CommentInputWidget> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _commentController,
                keyboardType: TextInputType.multiline,
                autofocus: true,
                maxLines: null,
                minLines: null,
                expands: true,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(hintText: "Write a comment..."),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    ref.read(dissCussionProvider.notifier).addComment(widget.postId, Comment(
                      name: ref.read(userProvider).name,
                      time: DateTime.now().toString(),
                      content: value,
                      profileImage: ref.read(userProvider).photoUrl,
                    ));
                    Navigator.pop(context);
                    _commentController.clear();
                  }
                }
              ),
            ),
          ),
          // IconButton(
          //   icon: Icon(Icons.send),
          //   onPressed: () {
          //     if (_commentController.text.trim().isNotEmpty) {
          //       ref.read(dissCussionProvider.notifier).addComment(widget.postId, Comment(
          //         name: ref.read(userProvider).name,
          //         time: DateTime.now().toString(),
          //         content: _commentController.text,
          //         profileImage: ref.read(userProvider).photoUrl,
          //       ));
          //       Navigator.pop(context);
          //       _commentController.clear();
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}