import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/models/post_model.dart';

import '../models/comment_model..dart';

class PostService {
  final CollectionReference _postReference =
      FirebaseFirestore.instance.collection('posts');

  Future<List<PostModel>> fetchPosts() async {
    try {
      QuerySnapshot result = await _postReference.get();

      // Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
      //     FirebaseFirestore.instance.collection('posts').snapshots();

      List<PostModel> posts = result.docs.map((e) {
        return PostModel.fromJson(e.id, e.data() as Map<String, dynamic>);
      }).toList();
      return posts;
    } catch (e) {
      throw e;
    }
  }

  Future<PostModel> getPostById(String id) async {
    try {
      DocumentSnapshot snapshot = await _postReference.doc(id).get();

      return PostModel(
        id: id,
        authorId: snapshot['authorId'],
        imageUrl: snapshot['imageUrl'],
        author: snapshot['author'],
        content: snapshot['content'],
        date: snapshot['date'],
        comments: snapshot['comments']
            .map(
              (comment) => CommentModel.fromJson(comment['id'], comment),
            )
            .toList(),
      );
    } catch (e) {
      throw e;
    }
  }

  Future<void> addComments(PostModel post) async {
    try {
      List<Map<String, dynamic>> comments_map = [];
      for (var element in post.comments) {
        comments_map.add(
          element.toJson(),
        );
      }
      DocumentReference docPost = _postReference.doc(post.id);
      await docPost.update({'comments': comments_map});
    } catch (e) {
      throw e;
    }
  }
}
