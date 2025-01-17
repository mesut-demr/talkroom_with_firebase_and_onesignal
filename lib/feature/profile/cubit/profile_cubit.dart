import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_system/feature/profile/cubit/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState.initial()) {
    init();
  }
  void init() {}

  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      if (userDoc.exists) {
        return userDoc.data();
      }
      return null;
    } catch (e) {
      print('Error pulling user information: $e');
      return null;
    }
  }

  String formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';
    final date = (timestamp as Timestamp).toDate();
    return '${date.day}/${date.month}/${date.year}';
  }
}
