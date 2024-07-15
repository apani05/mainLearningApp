import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'discuss_model.dart';

class FirestoreDiscussProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Post> _posts = [];
  bool _isLoading = false;
  StreamSubscription? _postsSubscription;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  FirestoreDiscussProvider() {
    fetchPosts();
  }

  @override
  void dispose() {
    _postsSubscription?.cancel(); // Cancel the subscription when the provider is disposed
    super.dispose();
  }
  Future<void> addPost(Post post) async {
    await _db.collection('Posts').add(post.toMap());
    await fetchPosts();
    notifyListeners();
  }

 Future<void> fetchPosts() async {
  _isLoading = true;
  notifyListeners();

  _postsSubscription?.cancel(); // Cancel any existing subscriptions
  _postsSubscription = _db.collection('Posts').snapshots().listen((snapshot) {
    _posts = snapshot.docs.map((doc) {
      var post = Post.fromMap(doc.data() as Map<String, dynamic>).copyWith(id: doc.id);
      // Listen for likes and comments updates for each post
      listenForLikes(post.id!);
      listenForComments(post.id!);
      return post;
    }).toList();
    _isLoading = false;
    notifyListeners();
  });
}

void listenForLikes(String postId) {
  _db.collection('Posts').doc(postId).collection('Likes').snapshots().listen((snapshot) {
    int likesCount = snapshot.docs.length;
    // Find the post and update its likes count
    int postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      _posts[postIndex] = _posts[postIndex].copyWith(likes: likesCount);
      notifyListeners();
    }
  });
}

void listenForComments(String postId) {
  _db.collection('Posts').doc(postId).collection('Comments').snapshots().listen((snapshot) {
    int commentsCount = snapshot.docs.length;
    // Find the post and update its comments count
    int postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      _posts[postIndex] = _posts[postIndex].copyWith(comments: commentsCount);
      notifyListeners();
    }
  });
}


  Future<void> toggleLike(String postId, String userId) async {
  final likeRef = _db.collection('Posts').doc(postId).collection('Likes').doc(userId);

  final likeSnapshot = await likeRef.get();

  if (likeSnapshot.exists) {
    // If like exists, remove it
    await likeRef.delete();
  } else {
    // If like does not exist, add it
    await likeRef.set({});
  }

  notifyListeners();
}

  Future<void> reportPost({required String postId, required String reporterId, required String reason}) async {
    try {
      await _db.collection('reports').add({
        'postId': postId,
        'reporterId': reporterId,
        'reason': reason,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      // Handle any errors
    }
  }

 Future<void> toggleComment(String postId, String userId) async {
  final commentRef = _db.collection('Posts').doc(postId).collection('Comments').doc(userId);

  final commentSnapshot = await commentRef.get();

  if (commentSnapshot.exists) {
    // If comment exists, remove it
    await commentRef.delete();
  } else {
    // If comment does not exist, add it
    await commentRef.set({});
  }

  notifyListeners();
 }

  Future<void> addComment(String postId, Comment comment) async {
    await _db.collection('Posts').doc(postId).collection('Comments').add(comment.toMap());
    notifyListeners();
  }

  Future<void> deleteComment(String postId, String commentId) async {
    await _db.collection('Posts').doc(postId).collection('Comments').doc(commentId).delete();
    notifyListeners();
  }
  Future<void> deletePost(String postId) async {
    await _db.collection('Posts').doc(postId).delete();
    notifyListeners();
  }
  Future<void> fetchComments(String postId) async {
    await _db.collection('Posts').doc(postId).collection('Comments').get().then((snapshot) {
      final comments = snapshot.docs
          .map((doc) => Comment.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      _posts.firstWhere((post) => post.id == postId).replies = comments;
      notifyListeners();
    });
  }

Stream<int> listenForLikesRT(String postId) {
  return _db.collection('Posts').doc(postId).collection('Likes').snapshots().map((snapshot) => snapshot.docs.length);
}

Stream<int> listenForCommentsRT(String postId) {
  return _db.collection('Posts').doc(postId).collection('Comments').snapshots().map((snapshot) => snapshot.docs.length);
}

Future<Post> fetchPostById(String postId) async {
  DocumentSnapshot postSnapshot = await _db.collection('Posts').doc(postId).get();
  if (postSnapshot.exists) {
    return Post.fromMap(postSnapshot.data() as Map<String, dynamic>).copyWith(id: postSnapshot.id);
  } else {
    throw Exception('Post not found');
  }
}

Future<List<Comment>> fetchCommentsByPostId(String postId) async {
  QuerySnapshot commentsSnapshot = await _db.collection('Posts').doc(postId).collection('Comments').get();
  return commentsSnapshot.docs.map((doc) => Comment.fromMap(doc.data() as Map<String, dynamic>)).toList();
}

Stream<List<Comment>> listenForRepliesRT(String postId) {
    var k = _db.collection('Posts').doc(postId).collection('Comments').snapshots().map((snapshot) => snapshot.docs.map((doc) => Comment.fromMap(doc.data())).toList());
    print(k);
  return k;
}
}