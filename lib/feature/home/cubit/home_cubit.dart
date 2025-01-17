import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_system/feature/home/cubit/home_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  //? controller
  final TextEditingController roomNameController = TextEditingController();
  final TextEditingController roomDescriptionController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  HomeCubit() : super(HomeState.initial()) {
    init();
  }
  void init() {
    fetchRooms();
  }

//? add room
  Future<void> addRoom(String name, String description) async {
    try {
      await FirebaseFirestore.instance.collection('rooms').add({
        'name': name,
        'description': description,
      });
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error, errorMessage: "There was an error adding the room."));
    }
  }

//? find room
  Stream<List<Map<String, dynamic>>> getRooms() {
    return FirebaseFirestore.instance.collection('rooms').snapshots().map((snapshot) => snapshot.docs.map((doc) {
          final data = doc.data();
          return {'id': doc.id, 'name': data['name'], 'description': data['description']};
        }).toList());
  }

//? fetch room info
  void fetchRooms() {
    FirebaseFirestore.instance.collection('rooms').snapshots().listen((snapshot) {
      try {
        final rooms = snapshot.docs.map((doc) {
          final data = doc.data();
          return {'id': doc.id, 'name': data['name'], 'description': data['description']};
        }).toList();
        emit(state.copyWith(status: HomeStatus.completed, rooms: rooms));
      } catch (e) {
        emit(state.copyWith(status: HomeStatus.error, errorMessage: "There was an error in bringing the rooms in."));
      }
    });
  }

//? id of the selected room
  void selectRoom(String roomId) {
    emit(state.copyWith(selectedRoomId: roomId));
  }

//? Bringing reviews by rooms
  Stream<List<Map<String, dynamic>>> getCommentsByRoom(String roomId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

//? get comments
  Stream<List<Map<String, dynamic>>> getComments() {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(state.selectedRoomId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id,
                'username': data['username'],
                'comment': data['comment'],
                'likes': data['likes'] ?? 0,
                'userId': data['userId'],
                'commentId': data['commentId'],
                'likedBy': List<String>.from(data['likedBy'] ?? []),
              };
            }).toList());
  }

//? add comment
  Future<void> addComment(String roomId, String userId, String username, String comment) async {
    try {
      final commentRef = FirebaseFirestore.instance.collection('rooms').doc(roomId).collection('comments').doc();
      final time = DateTime.now().toString();
      final commentData = {
        'commentId': commentRef.id,
        'userId': userId,
        'username': username,
        'comment': comment,
        'timestamp': time,
        'likes': 0,
        'likedBy': [],
      };

      await commentRef.set(commentData);

      print('Comment successfully added: $commentData');
    } catch (e) {
      print('Error adding a comment: $e');
    }
  }

//? send comment
  void submitComment() async {
    final comment = commentController.text.trim();

    if (comment.isEmpty) return;

    //* Get the UID of the logged in user from Firebase Authentication
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;

    //* Get your username from Firestore
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final username = userDoc.data()?['username'] ?? 'Unknown User';

    //* Add comment to Firestore
    await addComment(state.selectedRoomId, uid, username, comment);

    commentController.clear();
  }

//? like comment
  Future<void> likeComment(String roomId, String commentId, String likerUserId, String ownerUserId) async {
    try {
      final commentRef = FirebaseFirestore.instance.collection('rooms').doc(roomId).collection('comments').doc(commentId);
      final playerId = (await FirebaseFirestore.instance.collection('users').doc(ownerUserId).get()).data()?['playerId'];

      final likerSnapshot = await FirebaseFirestore.instance.collection('users').doc(likerUserId).get();
      final likerUsername = likerSnapshot.data()?['username'] ?? 'Bir kullanıcı';

      final commentSnapshot = await commentRef.get();
      if (!commentSnapshot.exists) {
        throw Exception('Document not found. commentId: $commentId');
      }

      final data = commentSnapshot.data();
      if (data != null) {
        final likedBy = List<String>.from(data['likedBy'] ?? []);

        if (likedBy.contains(likerUserId)) {
          //* If the user has already liked it, remove the like
          likedBy.remove(likerUserId);
          await commentRef.update({
            'likedBy': likedBy,
            'likes': (data['likes'] ?? 0) - 1,
          });

          //* send a notification when you unlike a comment
          await sendNotification(playerId: playerId, title: 'TalkRoom', body: '$likerUsername unliked your comment');
        } else {
          //* If the user doesn't like it, add the like
          likedBy.add(likerUserId);
          await commentRef.update({
            'likedBy': likedBy,
            'likes': (data['likes'] ?? 0) + 1,
          });

          //* send notification
          await sendNotification(playerId: playerId, title: 'TalkRoom', body: '$likerUsername liked your comment');
        }
      }
    } catch (e) {
      print('Error liking the comment: $e');
    }
  }

//? send notification
  Future<void> sendNotification({
    required String? playerId,
    required String title,
    required String body,
  }) async {
    if (playerId == null) {
      print("Player ID empty, unable to send notification");
      return;
    }

    final url = 'https://onesignal.com/api/v1/notifications';
    final appId = 'app_id'; //* OneSignal App ID
    final apiKey = 'api_key'; //* OneSignal REST API Key

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $apiKey',
      'Accept': 'application/json',
    };

    final payload = {
      'app_id': appId,
      'include_player_ids': [playerId],
      'headings': {'en': title},
      'contents': {'en': body},
      'android_notification_icon': 'ic_launcher',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully.");
      } else {
        print("Notification sending error: ${response.body}, ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending a notification: $e");
    }
  }
}
