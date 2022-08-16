import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:protobuddy/models/post_proto.dart';
import 'package:protobuddy/models/user.dart';

final userStream = StreamProvider((ref) => CrudProvider().getUser());
final postStream = StreamProvider((ref) => CrudProvider().getPosts());
final crudProvider = Provider((ref) => CrudProvider());
final singleUserStream =
    StreamProvider.autoDispose((ref) => CrudProvider().getSingleUser());

class CrudProvider {
  CollectionReference dbUser = FirebaseFirestore.instance.collection('users');
  CollectionReference dbPost = FirebaseFirestore.instance.collection('posts');
  Stream<List<User>> getUser() {
    return dbUser.snapshots().map((event) => _getQuery(event));
  }

  List<User> _getQuery(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((e) => User.formJson(e.data() as Map<String, dynamic>))
        .toList();
  }

  Future<String> addPost(
      {required String creatorName,
      required String speciality,
      required String education,
      required String experience,
      required String description,
      required String userId,
      required XFile file}) async {
    try {
      final imageId = DateTime.now().toString();
      final ref = FirebaseStorage.instance.ref().child('userPosts/$imageId');
      final convertFile = File(file.path);
      await ref.putFile(convertFile);
      final url = await ref.getDownloadURL();
      await dbPost.add({
        'imageUrl': url,
        'imageId': imageId,
        'creatorName': creatorName,
        'speciality': speciality,
        'education': education,
        'experience': experience,
        'description': description,
        'userId': userId,
        'likes': {'like': 0, 'usernames': []},
        'comments': []
      });
      return 'success';
    } on FirebaseException catch (err) {
      return '${err}';
    }
  }

  Stream<List<Postproto>> getPosts() {
    return dbPost.snapshots().map((event) => _getPostData(event));
  }

  List<Postproto> _getPostData(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      final dat = e.data() as Map<String, dynamic>;
      print(dat);
      return Postproto(
          id: e.id,
          imageId: dat['imageId'],
          userId: dat['userId'],
          description: dat['description'],
          imageUrl: dat['imageUrl'],
          likData: Like.formJson(dat['likes']),
          creatorName: dat['creatorName'],
          education: dat['education'],
          experience: dat['experience'],
          speciality: dat['speciality'],
          comments: (dat['comments'] as List)
              .map((e) => Comments.formJson(e))
              .toList());
    }).toList();
  }

  Stream<User> getSingleUser() {
    final uid = auth.FirebaseAuth.instance.currentUser!.uid;

    final user = dbUser.where('userId', isEqualTo: uid).snapshots();
    return user.map((event) => _getUserQuery(event));
  }

  User _getUserQuery(QuerySnapshot snapshot) {
    final user = snapshot.docs[0].data() as Map<String, dynamic>;
    return User.formJson(user);
  }

  Future<void> likePost(
      {required String postId, required Like likeData}) async {
    try {
      await dbPost.doc(postId).update({'likes': likeData.toJson()});
    } on FirebaseException catch (err) {
      print(err);
    }
  }

  Future<String> updatePost(
      {required String creatorName,
      required String speciality,
      required String education,
      required String experience,
      required String description,
      required String postId,
      String? imageId,
      XFile? file}) async {
    try {
      if (file == null) {
        await dbPost.doc(postId).update({
          'creatorName': creatorName,
          'speciality': speciality,
          'education': education,
          'experience': experience,
          'description': description,
        });
      } else {
        final ref = FirebaseStorage.instance.ref().child('userPosts/$imageId');
        await ref.delete();
        final imageId1 = DateTime.now().toString();
        final ref1 =
            FirebaseStorage.instance.ref().child('userPosts/$imageId1');
        final convertFile = File(file.path);
        await ref1.putFile(convertFile);
        final url = await ref1.getDownloadURL();

        await dbPost.doc(postId).update({
          'imageUrl': url,
          'imageId': imageId1,
          'creatorName': creatorName,
          'speciality': speciality,
          'education': education,
          'experience': experience,
          'description': description,
        });
      }

      return 'success';
    } on FirebaseException catch (err) {
      return '${err}';
    }
  }

  Future<String> removePost({
    required String postId,
    required String imageId,
  }) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('userPosts/$imageId');
      await ref.delete();

      await dbPost.doc(postId).delete();

      return 'success';
    } on FirebaseException catch (err) {
      return '${err}';
    }
  }
}
